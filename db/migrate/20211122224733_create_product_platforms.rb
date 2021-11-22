class CreateProductPlatforms < ActiveRecord::Migration[6.1]
  def change
    create_table :product_platforms do |t|
      t.references :platform, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
