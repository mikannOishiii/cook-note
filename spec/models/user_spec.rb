require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user)}

  it "有効なファクトリを持つこと" do
    expect(user).to be_valid
  end

  it "ユーザー名がなければ無効であること" do
    user.name = ""
    user.valid?
    expect(user).not_to be_valid
  end

  it "ユーザー名は21文字以上だと登録できない" do
    user.name = "a" * 21
    user.valid?
    expect(user).not_to be_valid
  end

  it "ユーザー名は20文字以内であること" do
    user.name = "a" * 20
    user.valid?
    expect(user).to be_valid
  end

  it "メールアドレスがなければ登録できない" do
    user.email = ""
    user.valid?
    expect(user).not_to be_valid
  end

  it "メールアドレスは256文字以上だと登録できない" do
    user.email = "a" * 244 + "@example.com"
    user.valid?
    expect(user).not_to be_valid
  end

  it "メールアドレスは255文字以内であること" do
    user.email = "a" * 243 + "@example.com"
    user.valid?
    expect(user).to be_valid
  end

  it "メールアドレスのフォーマットが正しくなければ登録できない" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.　foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |adress|
      user.email = adress
      user.valid?
      expect(user).not_to be_valid
    end
  end

  it  "メールアドレスが重複していたら登録できない" do
    duplicate_user = user.dup
    duplicate_user.email = user.email.upcase
    user.save
    expect(duplicate_user).not_to be_valid
  end

  it "メールアドレスはすべて小文字で保存される" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    expect(user.email).to eq mixed_case_email.downcase
  end

  it "パスワードがなければ登録できない" do
    user.password = user.password_confirmation = "" * 6
    user.valid?
    expect(user).not_to be_valid
  end

  it "パスワードは6文字以上ないと登録できない" do
    user.password = user.password_confirmation = "a" * 5
    user.valid?
    expect(user).not_to be_valid
  end

  it "ダイジェストが存在しない場合のauthenticated?のテスト" do
    user.authenticated?("")
    expect(user).to be_truthy
  end
end
