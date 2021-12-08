class Province < ApplicationRecord
  has_many :customers
  validates :name, presence: true, uniqueness: true
  validates :HST, :GST, :PST, presence: true
  has_many :users
end
