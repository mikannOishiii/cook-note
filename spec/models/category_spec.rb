require 'rails_helper'

RSpec.describe Category, type: :model do
  let!(:user) { create(:user) }
  let(:recipe) { user.recipes.create(name: "テストレシピ") }
  let(:category) { user.categories.build(name: "テストカテゴリ") }

  it "有効なファクトリを持つこと" do
    expect(category).to be_valid
  end

  it "カテゴリ名がなければ無効であること" do
    category.name = ""
    category.valid?
    expect(category).not_to be_valid
  end

  it "カテゴリ名50文字以上だと無効であること" do
    category.name = "a" * 51
    category.valid?
    expect(category).not_to be_valid
  end

  it "カテゴリ名は50文字以内なら有効であること" do
    category.name = "a" * 50
    expect(category).to be_valid
  end

  it "ユーザーが削除されると、カテゴリも削除されること" do
    category.save
    expect { user.destroy }.to change { Category.count }.by(-1)
  end

  it "ユーザーのカテゴリは重複しない" do
    # 同じユーザーはカテゴリ重複しない
    category.save
    other_category = user.categories.create(name: "テストカテゴリ")
    other_category.valid?
    expect(other_category).not_to be_valid
    # ユーザーが別ならカテゴリ重複しても良い
    other_user = create(:user, email: "other@example.com")
    other_category = other_user.categories.create(name: "テストカテゴリ")
    expect(other_category).to be_valid
  end
end
