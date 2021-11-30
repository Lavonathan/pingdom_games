class Province < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :HST, :GST, :PST, presence: true
end
