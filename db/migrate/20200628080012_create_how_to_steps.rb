class CreateHowToSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :how_to_steps do |t|
      t.integer :sort_order, null: false
      t.text :body, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :how_to_steps, [:recipe_id, :created_at]
  end
end
