require 'spec_helper'

describe Spree::Theme, type: :model do

  describe 'constants' do
    it { expect(Spree::Theme::DEFAULT_NAME).to eq(['default']) }
    it { expect(Spree::Theme::DEFAULT_STATE).to eq('drafted') }
    it { expect(Spree::Theme::TEMPLATE_FILE_CONTENT_TYPE).to eq('application/zip') }
    it { expect(Spree::Theme::STATES).to eq(['drafted', 'compiled', 'published']) }
    it { expect(Spree::Theme::THEMES_PATH).to eq("#{Rails.root}/public/vinsol_spree_themes") }
    it { expect(Spree::Theme::CURRENT_THEME_PATH).to eq("#{Rails.root}/public/vinsol_spree_themes/current") }
  end

  describe 'paperclip attachment' do
    it { is_expected.to have_attached_file :template_file }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_attachment_presence :template_file }
    it { is_expected.to validate_attachment_content_type(:template_file).allowing('application/zip').rejecting('image/png', 'text/plain') }
    it { is_expected.to validate_inclusion_of(:state).in_array([Spree::Theme::STATES]) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:themes_templates).dependent(:destroy) }
  end

end
