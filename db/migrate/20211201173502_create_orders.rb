class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :order_no
      t.decimal :payment_amount_no_tax
      t.decimal :GST
      t.decimal :HST
      t.decimal :PST
      t.decimal :payment_total
      t.date :pay_date
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
