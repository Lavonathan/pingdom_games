class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    User.delete_all

    add_reference :users, :province, null: false, foreign_key: true
  end
end
