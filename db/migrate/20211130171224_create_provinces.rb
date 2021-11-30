class CreateProvinces < ActiveRecord::Migration[6.1]
  def change
    create_table :provinces do |t|
      t.string  :name
      t.integer :GST
      t.integer :HST
      t.integer :PST
      t.string  :code

      t.timestamps
    end
  end
end
