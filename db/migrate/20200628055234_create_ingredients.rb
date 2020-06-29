class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.string :quantity_amount, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :ingredients, [:recipe_id, :created_at]
  end
end
