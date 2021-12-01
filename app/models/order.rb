class Order < ApplicationRecord
  belongs_to :customer
  validates :order_no, presence: true, uniqueness: true
  validates :payment_amount_no_tax, :payment_total, :pay_date, presence: true
end
