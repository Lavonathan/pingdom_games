class Order < ApplicationRecord
  belongs_to :user
  has_many :product_orders
  has_many :products, through: :product_orders
  validates :order_no, presence: true, uniqueness: true
  validates :payment_amount_no_tax, :payment_total, :pay_date, presence: true

  accepts_nested_attributes_for :product_orders, allow_destroy: true
end
