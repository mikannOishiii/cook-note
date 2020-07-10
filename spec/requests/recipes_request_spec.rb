require 'rails_helper'

RSpec.describe "Recipes", type: :request do
  let(:user) { create(:user) }  
  before { log_in_as(user) }

  describe "GET /new" do
    it "リクエストが成功すること" do
      get new_recipe_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "パラメータが妥当な場合" do
      subject { post recipes_url, params: { recipe: attributes_for(:recipe) } }

      it { is_expected.to eq 302 }
      it { expect { subject }.to change(Recipe, :count).by(1) }
      it { is_expected.to redirect_to Recipe.last }
    end

    context "パラメータが不正な場合" do
      subject { post recipes_url, params: { recipe: attributes_for(:recipe, name: "") } }

      it { is_expected.to eq 200 }
      it { expect { subject }.not_to change(Recipe, :count) }

      it "エラーが表示されること" do
        subject
        expect(response.body).to include "レシピ名を入力してください"
      end
    end
  end

  describe "GET /edit" do
    let!(:recipe) { user.recipes.create(name: "recipe_name") }

    it "リクエストが成功すること" do
      get edit_recipe_url(recipe.id)
      expect(response.status).to eq 200
    end
  end

  describe "PUT /update" do
    let(:recipe) { user.recipes.create(name: "サバの味噌煮") }

    context "パラメータが妥当な場合" do
      subject { put recipe_url recipe, params: { recipe: { id: recipe.id, name: "サバの甘辛煮" } } }

      it { is_expected.to eq 302 }

      it { expect { subject }.to change {
        Recipe.find(recipe.id).name }.from("サバの味噌煮").to("サバの甘辛煮")
      }

      it { is_expected.to redirect_to Recipe.last }
    end

    context "パラメータが不正な場合" do
      subject { put recipe_url recipe, params: { recipe: { id: recipe.id, name: "" } } }

      it { is_expected.to eq 200 }

      it { expect { subject }.not_to change(Recipe.find(recipe.id), :name) }

      it "エラーが表示されること" do
        subject
        expect(response.body).to include "レシピ名を入力してください"
      end
    end  
  end

  describe "DELETE #destroy" do
    let!(:recipe) { user.recipes.create(name: "recipe_name") }

    subject { delete recipe_url recipe }

    it { is_expected.to eq 302 }

    it { expect { subject }.to change(Recipe, :count).by(-1) }

    it { is_expected.to redirect_to recipes_url }
  end
end
