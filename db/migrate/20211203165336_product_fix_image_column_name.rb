class ProductFixImageColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :image, :image_url
  end
end
