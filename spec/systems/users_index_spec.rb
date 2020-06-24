require 'rails_helper'

RSpec.describe "ユーザー機能", type: :system do
  describe "ユーザー一覧機能" do
    let(:admin_user){ create(:user, admin: true) }
    let(:other_user){ create(:other_user) }
    
    context "管理者権限でログインしている場合" do
      before do
        visit login_path
        fill_in "メールアドレス", with: admin_user.email
        fill_in "パスワード", with: admin_user.password
        click_button "ログイン"
        visit users_path
      end

      it "ユーザー一覧・削除リンクが表示される" do
        first_page_of_users = User.page(1)
        first_page_of_users.each do |user|
          expect(page).to have_link user.name
          unless user == admin_user
            expect(page).to have_link "削除", href: user_path(user)
          end
        end
      end
    end

    context "管理者権限なしでログインしている場合" do
      before do
        visit login_path
        fill_in "メールアドレス", with: other_user.email
        fill_in "パスワード", with: other_user.password
        click_button "ログイン"
        visit users_path
      end

      it "削除リンクは表示されない" do
        expect(page).not_to have_content "削除"
      end
    end
  end
end
   