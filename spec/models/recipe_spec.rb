require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { user.recipes.build(name: "recipe_name") }

  it "有効なファクトリを持つこと" do
    expect(recipe).to be_valid
  end

  it "ユーザーがいなければ無効であること" do
    recipe.user_id = ""
    expect(recipe).not_to be_valid
  end

  it "レシピ名がなければ無効であること" do
    recipe.name = ""
    recipe.valid?
    expect(recipe).not_to be_valid
  end

  it "レシピ概要は140文字以内であること" do
    recipe.description = "a" * 141
    recipe.valid?
    expect(recipe).not_to be_valid
  end

  it "URLはURLであること" do
    recipe.url = "example.com"
    recipe.valid?
    expect(recipe).not_to be_valid
  end

  it "料理時間は数値であること" do
    recipe.cooktime = "str"
    recipe.valid?
    expect(recipe).not_to be_valid
  end
end
