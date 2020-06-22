require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /new" do
    it "リクエストが成功すること" do
      get signup_url
      expect(response).to have_http_status(:success)
    end
  end

end
