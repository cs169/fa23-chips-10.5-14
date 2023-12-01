# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
require 'rspec/rails'

RSpec.describe NewsItem, type: :model do
  describe 'Constants' do
    it 'has a list of valid ISSUES' do
      expected_issues = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security and Medicare',
                         'Abortion', 'Student Loans', 'Gun Control', 'Unemployment', 'Climate Change',
                         'Homelessness', 'Racism', 'Tax Reform', 'Net Neutrality', 'Religious Freedom',
                         'Border Security', 'Minimum Wage', 'Equal Pay']
      expect(NewsItem::ISSUES).to match_array(expected_issues)
    end
  end

  describe 'Validations' do
    let(:representative) { Representative.create(name: 'John Doe') }

    it 'is valid with a valid issue' do
      news_item = described_class.new(title: 'Test', link: 'Test',
                                      issue: 'Climate Change', representative: representative)
      expect(news_item).to be_valid
    end

    it 'is invalid with an invalid issue' do
      news_item = described_class.new(title: 'Test', link: 'Test', issue: 'Invalid Issue',
                                      representative: representative)
      expect(news_item).not_to be_valid
      expect(news_item.errors[:issue]).to include('is not a valid issue')
    end
  end

  describe 'Methods' do
    describe '.find_for' do
      let!(:representative) { Representative.create(name: 'Jane Doe') }
      let!(:news_item) do
        described_class.create(title: 'Test', link: 'Test',
                               issue: 'Climate Change', representative: representative)
      end

      it 'finds a news item for the given representative id' do
        found_news_item = described_class.find_for(representative.id)
        expect(found_news_item).to eq(news_item)
      end

      it 'returns nil if no news item found for the given representative id' do
        found_news_item = described_class.find_for(999) # Non-existing ID
        expect(found_news_item).to be_nil
      end
    end
  end
end
