require 'rails_helper'

RSpec.describe "Recipes", type: :system, js: true do
  let(:user){ create(:user) }
  let(:valid_url){ "https://cookpad.com/recipe/5336469" }

  before do
    visit login_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "レシピ作成機能" do
    it "新規作成画面が表示されること" do
      visit root_path
      click_on "レシピを一からつくる"
      expect(current_path).to eq new_recipe_path
    end

    it "新規作成に成功する" do
      visit new_recipe_path
      expect(page).to have_content("レシピをつくる")
      fill_in "recipe[name]", with: "レシピ名テスト"
      fill_in "recipe[description]", with: "レシピ概要テスト"
      fill_in "recipe[recipeYield]", with: "レシピ何人分テスト"
      fill_in "recipe[ingredients_attributes][0][name]", with: "材料テスト1"
      fill_in "recipe[ingredients_attributes][0][quantity_amount]", with: "分量テスト1"
      fill_in "recipe[cooktime]", with: "15"
      fill_in "recipe[steps_attributes][0][body]", with: "レシピ作り方テスト"
      click_button "保存する"
      expect(page).to have_content("レシピを作成しました")
      expect(current_path).to eq recipe_path(Recipe.last)
      # fill_inで入力した情報が表示される
      expect(page).to have_content("レシピ名テスト")
      expect(page).to have_content("レシピ概要テスト")
      expect(page).to have_content("レシピ何人分テスト")
      expect(page).to have_content("材料テスト1")
      expect(page).to have_content("分量テスト1")
      expect(page).to have_content("15")
      expect(page).to have_content("レシピ作り方テスト")
    end
  end

  describe "レシピインポート機能" do
    it "インポート画面が表示されること" do
      visit import_recipes_path
      expect(page).to have_content("URLを入力")
    end
  
    it "インポートに成功すること" do
      visit import_recipes_path
      fill_in "URL", with: valid_url
      click_button "レシピを取り込む"
      expect(page).to have_content("レシピを作成しました")
      expect(page).to have_link valid_url
      expect(current_path).to eq recipe_path(Recipe.last)
    end
  end
end