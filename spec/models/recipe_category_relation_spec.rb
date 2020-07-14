require 'rails_helper'

RSpec.describe RecipeCategoryRelation, type: :model do
  let!(:user) { create(:user) }
  let(:recipe) { user.recipes.create(name: "テストレシピ") }
  let(:category) { user.categories.create(name: "テストカテゴリ") }
  let(:follow_category) { recipe.recipe_category_relations.build(category_id: category.id) }
  let(:follow_recipe) { category.recipe_category_relations.build(recipe_id: recipe.id) }
  
  it "有効なファクトリを持つこと" do
    expect(follow_category).to be_valid
    expect(follow_recipe).to be_valid
  end

  it "カテゴリが指定されていなければ有効でないこと" do
    follow_category.category_id = ""
    expect(follow_category).not_to be_valid
  end

  it "レシピが指定されていなければ有効でないこと" do
    follow_recipe.recipe_id = ""
    expect(follow_recipe).not_to be_valid
  end

  it "カテゴリが削除されると中間テーブルも削除されること" do
    follow_category.save
    expect { category.destroy }.to change { RecipeCategoryRelation.count }.by(-1)
  end

  it "レシピが削除されると中間テーブルも削除されること" do
    follow_category.save
    expect { recipe.destroy }.to change { RecipeCategoryRelation.count }.by(-1)
  end
end
