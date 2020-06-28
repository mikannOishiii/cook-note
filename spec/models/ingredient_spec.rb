require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  let!(:user) { create(:user) }
  let!(:recipe) { user.recipes.create(name: "recipe_name") }
  let(:ingredient) { Ingredient.new(name: "砂糖", quantity_amount: "大さじ3", recipe_id: recipe.id) }

  it "有効なファクトリを持つこと" do
    expect(ingredient).to be_valid
  end

  it "レシピがなければ無効であること" do
    ingredient.recipe_id = ""
    expect(ingredient).not_to be_valid
  end

  it "材料名がなければ無効であること" do
    ingredient.name = ""
    ingredient.valid?
    expect(ingredient).not_to be_valid
  end

  it "量がなければ無効であること" do
    ingredient.quantity_amount = ""
    ingredient.valid?
    expect(ingredient).not_to be_valid
  end
end
