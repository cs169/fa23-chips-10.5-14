# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]

  def edit; end

  def search
    render :search
  end

  def new
    @news_item = NewsItem.new
    set_articles_for_representative
  end

  def create
    selected_article = params[:selected_article].split('|||')
    @news_item = NewsItem.new(news_item_params)
    @news_item.title = selected_article[0]
    @news_item.description = selected_article[1]
    @news_item.link = selected_article[2]

    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      set_articles_for_representative
      render :new
    end
  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  private

  def set_articles_for_representative
    @representative = Representative.find(params[:representative_id])
    api_key = Rails.application.credentials[:GOOGLE_NEWS_API_KEY]
    query = "#{@representative.name}+#{params[:issue]}"
    url = "https://newsapi.org/v2/everything?q=#{query}&pageSize=5&apiKey=#{api_key}"
    uri = URI.parse(url)
    raise ArgumentError, 'Invalid URL scheme' unless %w[http https].include?(uri.scheme)

    response = Net::HTTP.get_response(uri)
    article_serialized = response.body
    @articles = JSON.parse(article_serialized)
  rescue StandardError => e
    @articles = { 'articles' => [] }
    flash.now[:error] = "Error fetching articles: #{e.message}"
  end

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :representative_id, :issue,
                                      ratings_attributes: [:value])
  end
end
