class Product < ApplicationRecord
  belongs_to :publisher
  validates :name, :game_id, presence: true, uniqueness: true
end
