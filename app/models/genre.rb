class Genre < ApplicationRecord
  has_many :product_genres
  has_many :products, through: :product_genres
  validates :name, presence: true, uniqueness: true
end
