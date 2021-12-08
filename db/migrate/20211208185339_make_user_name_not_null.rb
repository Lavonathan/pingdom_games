class MakeUserNameNotNull < ActiveRecord::Migration[6.1]
  def change
    User.where(user_name: nil).update_all(user_name: "Test")

    change_column :users, :user_name, :string, null: false
  end
end
