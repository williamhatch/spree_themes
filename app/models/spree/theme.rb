module Spree
  class Theme < Spree::Base

    DEFAULT_NAME = %w(default)
    DEFAULT_STATE = 'drafted'
    TEMPLATE_FILE_CONTENT_TYPE = 'application/zip'
    STATES = %w(drafted compiled published)
    FILESYSTEM_PATH = "#{ Rails.root }/public/themes"
    CURRENT_THEME_PATH = "#{ Rails.root }/public/themes/current"

    has_attached_file :template_file, path: 'public/system/spree/themes/:filename'

    ## VALIDATIONS ##
    validates_attachment :template_file, presence: true,
                                         content_type: { content_type: TEMPLATE_FILE_CONTENT_TYPE }
    validates :name, presence: true,
                     uniqueness: { case_sensitive: false }
    validates :state, inclusion: { in: STATES }
    validate :ensure_atleast_one_published_theme, if: :state_changed?, unless: :published?

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

    ## STATE MACHINES ##
    state_machine initial: :drafted do
      before_transition :drafted => :compiled, do: :assets_precompile

      before_transition :published => :drafted do  |theme, transition|
        theme.remove_current_theme
      end

      before_transition :compiled => :published do |theme, transition|
        theme.remove_current_theme
        theme.apply_theme_to_store
        theme.append_manifest_files
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
      AssetsPrecompilerService.minify(self)
    end

    def remove_current_theme
      Spree::Theme.published.each(&:draft)
      File.delete(CURRENT_THEME_PATH) if File.exist?(CURRENT_THEME_PATH)
    end

    def apply_theme_to_store
      FileUtils.ln_s("#{ FILESYSTEM_PATH }/#{ name }", CURRENT_THEME_PATH)
      Rails.cache.clear
    end

    def append_manifest_files
      File.open('vendor/assets/javascripts/spree/frontend/all.js', 'a+') { |file| file << "//= require #{ name }\n" }
      # File.open('vendor/assets/stylesheets/spree/frontend/all.css', 'a+') { |file| file << }
      # append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require public/themes/current/javascripts/#{ name }\n"
      # inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require public/themes/current/stylesheets/#{ name }", before: /\*\//, verbose: true
    end

    private

      def ensure_atleast_one_published_theme
        errors.add(:base, Spree.t('models.theme.minimum_active_error')) unless Spree::Theme.published.one?
      end

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
