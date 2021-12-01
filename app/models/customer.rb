class Customer < ApplicationRecord
  belongs_to :province
  validates :full_name, presence: true, uniqueness: true
  validates :first_name, :last_name, :postal_code, :address, :email, presence: true
end
