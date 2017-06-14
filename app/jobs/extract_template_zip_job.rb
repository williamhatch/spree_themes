# class ExtractTemplateZipJob < Struct.new(:theme_id)

#   def enqueue(job)
#     job.run_at = Time.now
#   end

#   def perform
#     ZipFileExtractor.new(file_path).extract
#   end

#   def self.enqueue(theme_id)
#     Delayed::Job.enqueue(new(theme_id))
#   end

#   def file_path
#     theme.template_file.path
#   end

#   def theme
#     @theme ||= Spree::Theme.where(id: theme_id).first
#   end

# end
