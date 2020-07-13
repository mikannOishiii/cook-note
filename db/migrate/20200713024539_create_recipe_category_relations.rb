class CreateRecipeCategoryRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_category_relations do |t|
      t.integer :recipe_id
      t.integer :category_id

      t.timestamps
    end
    add_index :recipe_category_relations, :recipe_id
    add_index :recipe_category_relations, :category_id
    add_index :recipe_category_relations, [:recipe_id, :category_id], unique: true
  end
end

