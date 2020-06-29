class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.text   :description
      t.string :url
      t.string :image
      t.string :recipeYield
      t.integer :cooktime
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recipes, [:user_id, :created_at]
  end
end
