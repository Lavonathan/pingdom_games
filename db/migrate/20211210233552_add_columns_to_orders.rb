class AddColumnsToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :status, :string
    add_column :orders, :address, :string
    add_column :orders, :postal_code, :string
  end
end
