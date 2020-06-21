require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET home" do
    it 'リクエストが成功すること' do
      get static_pages_home_url
      expect(response.status).to eq 200
    end
  end
end
