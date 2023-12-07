class Rating < ApplicationRecord
  belongs_to :news_item

  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
end
