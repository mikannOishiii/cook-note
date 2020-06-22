require 'rails_helper'

RSpec.describe SessionsHelper do
  include SessionsHelper
  let(:user){ create(:user) }

  before do
    remember(user)
  end

  it "current_user returns right user when session is nil" do
    expect(user).to eq current_user
    !session[:user_id].nil?
  end

  it "current_user returns nil when remember digest is wrong" do
    user.update_attribute(:remember_digest, User.digest(User.new_token))
    expect(current_user).to eq nil
  end
end