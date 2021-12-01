class AddFullNameToCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :customers, :full_name, :string
  end
end
