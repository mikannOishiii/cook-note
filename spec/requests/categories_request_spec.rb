require 'rails_helper'

RSpec.describe "Categories", type: :request do
  let(:user) { create(:user) }  
  before { log_in_as(user) }

  describe "GET /new" do
    it "リクエストが成功すること" do
      get new_category_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      subject { post categories_url, params: { category: attributes_for(:category) } }

      it { is_expected.to eq 302 }
      it { expect { subject }.to change(Category, :count).by(1) }
      it { is_expected.to redirect_to new_category_url }
    end

    context "パラメータが不正な場合" do
      subject { post categories_url, params: { category: attributes_for(:category, name: "") } }

      it { is_expected.to eq 200 }
      it { expect { subject }.not_to change(Category, :count) }

      it "エラーが表示されること" do
        subject
        expect(response.body).to include "カテゴリ名を入力してください"
      end
    end
  end

  describe "GET /edit" do
    let!(:category) { user.categories.create(name: "カテゴリテスト") }

    it "リクエストが成功すること" do
      get edit_category_url(category.id)
      expect(response.status).to eq 200
    end
  end

  describe "PUT /update" do
    let(:category) { user.categories.create(name: "カテゴリテスト") }

    context "パラメータが妥当な場合" do
      subject { put category_url category, params: { category: { id: category.id, name: "カテゴリテスト2" } } }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change {
        Category.find(category.id).name }.from("カテゴリテスト").to("カテゴリテスト2")
      }

      it { is_expected.to redirect_to new_category_url }
    end

    context "パラメータが不正な場合" do
      subject { put category_url category, params: { category: { id: category.id, name: "" } } }

      it { is_expected.to eq 200 }

      it { expect { subject }.not_to change(Category.find(category.id), :name) }

      it "エラーが表示されること" do
        subject
        expect(response.body).to include "カテゴリ名を入力してください"
      end
    end  
  end

  describe "DELETE #destroy" do
    let!(:category) { user.categories.create(name: "カテゴリテスト") }

    subject { delete category_url category }

    it { is_expected.to eq 302 }

    it { expect { subject }.to change(Category, :count).by(-1) }

    it { is_expected.to redirect_to new_category_url }
  end

end
