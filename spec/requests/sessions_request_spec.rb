require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET #new" do
    it "リクエストが成功すること" do
      get login_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    subject { post login_url, params: { session: { email: email, password: user.password } } }

    context "パラメータが妥当な場合" do
      let(:email) { user.email }

      it { is_expected.to eq 302 }
      it { is_expected.to redirect_to root_url }
    end

    context "パラメータが不正の場合" do
      let(:email) { "invalid@example.com" }

      it { is_expected.to eq 200 }
      
      it "エラーが表示されること" do
        subject
        expect(response.body).to include "メールアドレスまたはパスワードが違います"
      end
    end
  end

  describe "Remember me" do
    before do
      post login_url, params: {
        session: { email: user.email, password: user.password, remember_me: status } 
      }
    end
    
    context "login with remembering" do
      let(:status) { "1" }

      it "cookieが格納されていること" do
        expect(response.cookies['remember_token']).to_not eq nil
      end
    end

    context "login without remembering" do
      let(:status) { "0" }

      it "cookieが格納されていないこと" do
        expect(response.cookies['remember_token']).to eq nil
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete logout_url }

    before do
      post login_url, params: { session: { email: user.email, password: user.password } }
    end

    it { is_expected.to eq 302 }
    it { is_expected.to redirect_to root_url }
  end
end
