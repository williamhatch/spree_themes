module Spree
  class Theme < Spree::Base

    DEFAULT_NAME = %w(default)
    DEFAULT_STATE = 'drafted'
    TEMPLATE_FILE_CONTENT_TYPE = 'application/zip'
    STATES = %w(drafted compiled published)
    #FIXME_AB: We are planning to name this extension as vinsol_spree_themes so can we make this path as public/vinsol_spree_themes.
    #FIXME_AB: Also use File.join to make path.
    #FIXME_AB: Rename this variable to THEMES_PATH
    FILESYSTEM_PATH = "#{ Rails.root }/public/themes"
    #FIXME_AB: Reuse THEMES_PATH
    CURRENT_THEME_PATH = "#{ Rails.root }/public/themes/current"

    #FIXME_AB: Add storate to filesystem. Paperclip can have global setting to store uploaded files on s3. Here we want to ensure that files are on disk.
    has_attached_file :template_file, path: 'public/system/spree/themes/:filename'

    ## VALIDATIONS ##
    validates_attachment :template_file, presence: true,
                                         content_type: { content_type: TEMPLATE_FILE_CONTENT_TYPE }
    validates :name, presence: true,
                     uniqueness: { case_sensitive: false }
    validates :state, inclusion: { in: STATES }

    # FIX_ME_PG:- check for atleast one published theme.
    # validate :ensure_atleast_one_published_theme, if: :state_changed?, unless: :published?

    ## ASSOCIATIONS ##
    has_many :themes_templates, dependent: :destroy

    ## CALLBACKS ##
    before_validation :set_name
    before_validation :set_state, unless: :state?
    after_commit :extract_template_zip_file, on: :create

    ## SCOPES ##
    scope :published, -> { where(state: 'published') }
    scope :default, -> { where(name: DEFAULT_NAME) }

    alias_method :templates, :themes_templates

    self.whitelisted_ransackable_attributes = %w( name state )

    ## STATE MACHINES ##
    state_machine initial: :drafted do
      #FIXME_AB: use new hash syntax everywhere
      before_transition :drafted => :compiled, do: :assets_precompile

      # before_transition :published => :drafted do  |theme, transition|
      #   theme.remove_current_theme
      # end

      before_transition :compiled => :published do |theme, transition|
        theme.remove_current_theme
        theme.apply_new_theme
        theme.update_cache_timestamp
      end

      event :draft do
        transition [:published, :compiled] => :drafted
      end

      event :compile do
        transition :drafted => :compiled
      end

      event :publish do
        transition [:compiled, :drafted] => :published
      end
    end

    def assets_precompile
      AssetsPrecompilerService.new(self).minify
    end

    def remove_current_theme
      Spree::Theme.published.each(&:draft)
      File.delete(CURRENT_THEME_PATH) if File.exist?(CURRENT_THEME_PATH)
    end

    def apply_new_theme
      #FIXME_AB: use File.join
      FileUtils.ln_s("#{ FILESYSTEM_PATH }/#{ name }", CURRENT_THEME_PATH)
      AssetsPrecompilerService.new(self).copy_assets
    end

    def update_cache_timestamp
      Rails.cache.write(Spree::ThemesTemplate::Resolver.cache_key, Time.current)
    end

    private

      # def ensure_atleast_one_published_theme
      #   errors.add(:base, Spree.t('models.theme.minimum_active_error')) unless Spree::Theme.published.one?
      # end

      def set_name
        self.name = File.basename(template_file_file_name, File.extname(template_file_file_name))
      end

      def set_state
        self.state = DEFAULT_STATE
      end

      def extract_template_zip_file
        ZipFileExtractor.new(template_file.path, self).extract
      end

  end
end
