require 'rails_helper'

RSpec.describe Step, type: :model do
  let!(:user) { create(:user) }
  let!(:recipe) { user.recipes.create(name: "recipe_name") }
  let(:steps) { build_list(:step, 3, recipe_id: recipe.id) }

  it "有効なファクトリを持つこと" do
    steps.each do |step|
      expect(step).to be_valid
    end
  end

  it "レシピがなければ無効であること" do
    steps.each do |step|
      step.recipe_id = ""
      expect(step).not_to be_valid
    end
  end

  it "作り方がなければ無効であること" do
    steps.each do |step|
      step.body = ""
      step.valid?
      expect(step).not_to be_valid
    end
  end
end
