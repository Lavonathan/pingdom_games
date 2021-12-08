class AddUserToOrder < ActiveRecord::Migration[6.1]
  def change
    ProductOrder.delete_all
    Order.delete_all
    Customer.delete_all
    remove_column :orders, :customer_id
    add_reference :orders, :user, null: false, foreign_key: true

    # puts "Creating test order"
    # test_product = Product.first
    # product_price = test_product.price
    # product_quantity = 20
    # payment_no_tax = product_price * product_quantity
    # gst_amount = product_price * User.first.province.GST / 100
    # hst_amount = product_price * User.first.province.HST / 100
    # pst_amount = product_price * User.first.province.PST / 100
    # payment_total = payment_no_tax + gst_amount + hst_amount + pst_amount

    # test_order = Order.create(order_no: 123, payment_amount_no_tax: payment_no_tax, GST: gst_amount, HST: hst_amount, PST: pst_amount,
    #                       payment_total: payment_total, pay_date: Date.current, user: User.first)

    # test_order = Order.create(order_no: 124, payment_amount_no_tax: payment_no_tax, GST: gst_amount, HST: hst_amount, PST: pst_amount,
    #                       payment_total: payment_total, pay_date: Date.current, user: User.first)
  end
end
