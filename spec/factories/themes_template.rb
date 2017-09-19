FactoryGirl.define do
  factory :themes_template
    name { Faker::File.file_name }
    body { Faker::Lorem.paragraph }
    path { "#{Rails.root}/tmp" }
    format { Mime::SET.symbols.map(&:to_s).sample }
    locale { I18n.available_locales.map(&:to_s).sample }
    handler { ActionView::Template::Handlers.extensions.map(&:to_s).sample }
  end
end
