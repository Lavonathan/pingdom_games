class ProductPlatform < ApplicationRecord
  belongs_to :platform
  belongs_to :product
end
