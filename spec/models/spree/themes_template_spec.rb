require 'spec_helper'

describe Spree::ThemesTemplate, type: :model do
  let(:themes_template) { Spree::ThemesTemplate.new }

  describe 'constants' do
    it { expect(Spree::ThemesTemplate::DEFAULT_LOCALE).to eq('en') }
    it { expect(Spree::ThemesTemplate::DEFAULT_PATH).to eq('public/vinsol_spree_themes') }
    it { expect(Spree::ThemesTemplate::ASSETS_FILE_EXTENSIONS).to eq(['.js', '.css']) }
  end

  describe 'attr_accessors' do
    it { should have_attr_accessor(:created_by_admin) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :path }
    it { is_expected.to validate_inclusion_of(:format).in_array(Mime::SET.symbols.map(&:to_s)).allow_nil }
    pending { is_expected.to validate_inclusion_of(:locale).in_array(I18n.available_locales.map(&:to_s)) }
    it { is_expected.to validate_inclusion_of(:handler).in_array(ActionView::Template::Handlers.extensions.map(&:to_s)).allow_nil }
  end

  describe 'associations' do
    it { is_expected.to belong_to :theme }
  end

  pending 'callbacks' do
    it { expect(themes_template).to callback(:set_default_locale).before(:validation).unless(:locale?) }
    it { expect(themes_template).to callback(:set_public_path).before(:create).if(:created_by_admin?) }
    it { expect(themes_template).to callback(:update_cache_timestamp).after(:save) }
    it { expect(themes_template).to callback(:update_public_file).after(:save) }
    it { expect(themes_template).to callback(:precompile_assets).after(:save).if(:theme_published?) }
    it { expect(themes_template).to callback(:precompile_assets).after(:save).if(:assets_file?) }
  end

  describe 'delegators' do
    it { should delegate_method(:theme_name).to(:theme).as(:name) }
  end

  # PRIVATE METHODS
  describe '#update_cache_timestamp' do
    it { expect(themes_template.send :update_cache_timestamp).to be true }
    it { expect(Rails.cache.read(Spree::ThemesTemplate::CacheResolver.cache_key)).to_not be nil }
  end

  describe '#set_default_locale' do
    context 'when initializing themes_template object' do
      it { expect(themes_template.locale).to be_nil }
    end

    context 'when setting locale' do
      before { themes_template.send :set_default_locale }
      it { expect(themes_template.locale).to_not be nil }
      it { expect(themes_template.locale).to eq(Spree::ThemesTemplate::DEFAULT_LOCALE) }
    end
  end

  pending '#set_public_path' do
    context 'when initializing themes_template object' do
      it { expect(themes_template.path).to be_nil }
    end

    context 'when setting public path' do
      before { themes_template.send :set_public_path }
      it { expect(themes_template.set_public_path).to_not be nil }
      it { expect(themes_template.set_public_path).to eq('') }
    end
  end

  pending '#update_public_file'
  pending 'precompile_assets'
  pending 'theme_published?'
  pending 'assets_file?'

end
