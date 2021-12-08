class FixUserNameColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :name, :user_name
  end
end
