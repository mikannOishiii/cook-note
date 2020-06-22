require 'rails_helper'

RSpec.describe "ユーザー機能", type: :system do
  let(:user){ create(:user) }

  before do
    visit login_path
    fill_in "メールアドレス", with: email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
  end

  describe "ユーザーログイン機能" do
    context "パラメータが妥当な場合" do
      let(:email) { user.email }

      it "ログインメッセージが表示される" do
        expect(page).to have_content "ログインしました"
      end

      it "rootにリダイレクトされる" do
        expect(current_path).to eq root_path
      end
    end

    context "パラメータが不正な場合" do
      let(:email) { "invalid@example.com" }

      it "エラーメッセージが表示される" do
        expect(page).to have_content "メールアドレスまたはパスワードが違います"
      end

      it "ログインフォームに戻される" do
        expect(current_path).to eq login_path
      end
    end
  end

  describe "ユーザーログアウト機能" do
    let(:email) { user.email }

    before do
      click_link "ログアウト"
    end

    it "ログアウトメッセージが表示される" do
      expect(page).to have_content "ログアウトしました"
    end

    it "rootにリダイレクトされる" do
      expect(current_path).to eq root_path
    end
  end
end