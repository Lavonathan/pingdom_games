class Product < ApplicationRecord
  belongs_to :publisher
  has_many :product_platforms
  has_many :platforms, through: :product_platforms
  has_many :product_genres
  has_many :genres, through: :product_genres
  has_many :platforms, through: :product_platforms
  validates :name, :game_id, presence: true, uniqueness: true
end
