require 'rails_helper'

RSpec.describe "ユーザー機能", type: :system do
  describe "ユーザー登録機能" do
    let(:user){ build(:user, name: name) }

    before do
      visit new_user_path
      fill_in "ユーザー名", with: name
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "foobar"
      fill_in "パスワード（確認）", with: "foobar"
      click_button "登録する"
    end

    context "パラメータが妥当な場合" do
      let(:name) { "testuser" }

      it "登録完了のメッセージが表示される" do
        expect(page).to have_content "cook-note へようこそ！!"
      end

      it "rootにリダイレクトされる" do
        expect(current_path).to eq root_path
      end
    end

    context "パラメータが不正な場合" do
      let(:name) { "" }

      it "エラーメッセージが表示される" do
        expect(page).to have_content "ユーザー名を入力してください"
      end

      it "新規登録フォームに戻される" do
        expect(current_path).to eq signup_path
      end
    end
  end

end