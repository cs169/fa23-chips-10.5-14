# frozen_string_literal: true

require 'rails_helper'

describe NewsItemsController do
  let(:representative) do
    Representative.create!(
      name:      'John Doe',
      ocdid:     'Some ID',
      title:     'Representative Title',
      party:     'Some Party',
      photo_url: 'http://example.com/photo.jpg',
      address:   '123 Example Street'
    )
  end
  let(:news_item) do
    NewsItem.create!(
      title:             'Example News Title',
      link:              'http://example.com/news',
      description:       'Example description of the news item.',
      representative_id: representative.id,
      issue:             'Gun Control'
    )
  end

  describe '.index' do
    before do
      get :index, params: { representative_id: representative.id }
    end

    it 'assigns @news_items' do
      expect(assigns(:news_items)).to eq([news_item])
    end
  end

  describe '.show' do
    before do
      get :show, params: { id: news_item.id, representative_id: representative.id }
    end

    it 'assigns @news_item' do
      expect(assigns(:news_item)).to eq(news_item)
    end
  end
end
