require 'rails_helper'

RSpec.describe HowToStep, type: :model do
  let!(:user) { create(:user) }
  let!(:recipe) { user.recipes.create(name: "recipe_name") }
  let(:how_to_step) { recipe.how_to_steps.build(sort_order: 1, body: "recipe_description") }

  it "有効なファクトリを持つこと" do
    expect(how_to_step).to be_valid
  end

  it "レシピがなければ無効であること" do
    how_to_step.recipe_id = ""
    how_to_step.valid?
    expect(how_to_step).not_to be_valid
  end

  it "連番がなければ無効であること" do
    how_to_step.sort_order = ""
    how_to_step.valid?
    expect(how_to_step).not_to be_valid
  end

  it "説明文がなければ無効であること" do
    how_to_step.body = ""
    how_to_step.valid?
    expect(how_to_step).not_to be_valid
  end
end
