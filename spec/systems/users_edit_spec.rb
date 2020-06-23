require 'rails_helper'

RSpec.describe "ユーザー機能", type: :system do
  let(:user) { create(:user) }

  describe "ユーザー編集機能" do
    before do
      visit login_path
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    subject do
      visit edit_user_path(user)
      fill_in "ユーザー名", with: update_name
      fill_in "メールアドレス", with: "test@example.com"
      fill_in "パスワード", with: "foobar"
      fill_in "パスワード（確認）", with: "foobar"
      click_button "更新する"
    end

    context "パラメータが妥当な場合" do
      let(:update_name) { "update_name" }

      it "更新メッセージが表示される" do
        subject
        expect(page).to have_content "プロフィールを更新しました"
      end

      it "更新したプロフィールが表示されている" do
        subject
        expect(page).to have_content "update_name"
      end
    end

    context "パラメータが不正な場合" do
      let(:update_name) { "" }

      it "エラーメッセージが表示される" do
        subject
        expect(page).to have_content "ユーザー名を入力してください"
      end
    end
  end

  describe "with friendly forwarding" do
    before do
      visit edit_user_path(user)
      # redirect_to login_url 
      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: user.password
      click_button "ログイン"
    end

    it "元いたページにリダイレクトする" do
      expect(current_path).to eq edit_user_path(user)
    end  
  end
end