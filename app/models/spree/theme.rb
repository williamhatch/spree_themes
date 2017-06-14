module Spree
  class Theme < Spree::Base

    DEFAULT_NAME = %w(default)
    TEMPLATE_FILE_CONTENT_TYPE = 'application/zip'

    has_attached_file :template_file, path: 'public/system/spree/themes/:filename'

    ## VALIDATIONS ##
    validates_attachment :template_file, presence: true,
                                         content_type: { content_type: TEMPLATE_FILE_CONTENT_TYPE }
    validates :name, presence: true,
                     uniqueness: { case_sensitive: false }
    validate :ensure_atleast_one_active_theme, if: :enabled_changed? && :enabled_was

    ## ASSOCIATIONS ##
    has_many :themes_templates, dependent: :destroy

    ## CALLBACKS ##
    before_validation :set_name
    after_commit :extract_template_zip_file, on: :create

    define_model_callbacks :enable, only: [:before, :after]
    before_enable :disable_current_theme
    after_enable :clear_template_cache

    ## SCOPES ##
    scope :enabled, -> { where(enabled: true) }
    scope :default, -> { where(name: DEFAULT_NAME) }

    alias_method :templates, :themes_templates

    def deactivate!
      update(enabled: false)
    end

    def activate!
      run_callbacks :enable do
        update(enabled: true)
      end
    end

    private

      # def extract_template_zip_file
      #   ExtractTemplateZipJob.enqueue(id)
      # end

      def ensure_atleast_one_active_theme
        errors.add(:base, Spree.t('models.theme.minimum_active_error')) if Spree::Theme.enabled.one?
      end

      def set_name
        self.name = File.basename(template_file_file_name, File.extname(template_file_file_name))
      end

      def extract_template_zip_file
        ZipFileExtractor.new(template_file.path, self).extract
      end

      def disable_current_theme
        Spree::Theme.enabled.update_all(enabled: false) if Spree::Theme.enabled.any?
      end

      def clear_template_cache
        Spree::ThemesTemplate::Resolver.instance.clear_cache
      end

  end
end
