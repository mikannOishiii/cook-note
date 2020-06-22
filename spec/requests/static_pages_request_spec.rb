require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET home" do
    it 'リクエストが成功すること' do
      get root_url
      expect(response).to have_http_status(:success)
    end
  end
end
