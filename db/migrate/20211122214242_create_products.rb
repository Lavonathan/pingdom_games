class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :game_id
      t.decimal :general_rating
      t.decimal :metacritic_rating
      t.string :esrb_rating
      t.string :image
      t.string :release_date
      t.references :publisher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
