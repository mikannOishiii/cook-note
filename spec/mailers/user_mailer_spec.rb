require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }

  describe "account_activation" do
    let(:mail) { UserMailer.account_activation(user) }

    # メール送信
    it "renders the headers" do
      expect(mail.subject).to eq "Account activation"
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq(["noreply@example.com"])
    end

    # メールプレビュー
    it "renders the body" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset(user) }

    before { user.reset_token = User.new_token }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["test@example.com"])
      expect(mail.from).to eq(["noreply@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.reset_token
      expect(mail.body.encoded).to match CGI.escape(user.email)
    end
  end
end
