class Platform < ApplicationRecord
  has_many :product_platforms
  has_many :products, through: :product_platforms
  validates :name, presence: true, uniqueness: true
end
