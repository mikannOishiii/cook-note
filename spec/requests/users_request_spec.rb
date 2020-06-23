require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    let(:user) { create(:user) }
    subject { get users_url }

    it { is_expected.to eq 200 }
  end

  describe "GET /new" do
    subject { get signup_url }
    
    it { is_expected.to eq 200 }
  end

  describe "GET /edit" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, name: "other_user", email: "other@example.com") }
    subject { get edit_user_path(user) }

    context "ログインしているとき" do
      before { log_in_as(user) }
  
      it { is_expected.to eq 200 }
  
      it "プロフィールが表示されていること" do
        subject
        expect(response.body).to include user.name
        expect(response.body).to include user.email
      end
    end

    context "違うユーザーでログインしているとき" do
      before { log_in_as(other_user) }

      it { is_expected.to eq 302 }

      it { is_expected.to redirect_to root_url }
    end

    context "ログインしていないとき" do
      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to login_path }
    end
  end

  describe "PUT /update" do
    let(:user){ create(:user, name: "test_name") }

    before { log_in_as(user) }

    context "パラメータが妥当な場合" do
      subject { put user_url user, params: { user: attributes_for(:user, name: "update_name") } }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change { User.find(user.id).name }.from("test_name").to("update_name") }

      it { is_expected.to redirect_to User.last }
    end

    context "パラメータが不正の場合" do
      subject { put user_url user, params: { user: attributes_for(:user, :invalid) } }

      it { is_expected.to eq 200 }

      it { expect { subject }.not_to change(User.find(user.id), :name) }

      it "エラーが表示されること" do
        subject
        expect(response.body).to include "ユーザー名を入力してください"
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:user) { create(:user, admin: true) }
    let!(:other_user) { create(:other_user) }

    subject { delete user_path(user) }

    context "ログインしていないとき" do

      it { is_expected.to eq 302 }

      it { expect { subject }.not_to change(User, :count) }

      it { is_expected.to redirect_to login_path }
    end

    context "管理者権限のあるアカウントでログインしているとき" do

      before { log_in_as(user) }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change(User, :count).by(-1) }

      it { is_expected.to redirect_to users_path }
    end

    context "管理者権限のないアカウントでログインしているとき" do

      before { log_in_as(other_user) }

      it { is_expected.to eq 302 }

      it { expect { subject }.not_to change(User, :count) }

      it { is_expected.to redirect_to root_path }
    end
  end
end