class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.string :body, null: false
      t.references :recipe, null: false, foreign_key: true
      
      t.timestamps
    end
    add_index :steps, [:recipe_id, :created_at]
  end
end
