class RecipesController < ApplicationController
  before_action :check_url, only: [:confirm]
  before_action :redirect_login

  def show
    @recipe = Recipe.find(params[:id])
  end

  def index
    @recipes = current_user.recipes.all
  end

  def new
    @recipe = Recipe.new
    @recipe.ingredients.build
    @recipe.steps.build
  end

  def import   
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    if @recipe.save
      flash[:success] = "レシピを作成しました"
      redirect_to @recipe
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:recipe][:id])

    if @recipe.update(recipe_params)
      flash[:success] = "レシピを更新しました"
      redirect_to @recipe
    else
      render :edit
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_url
    flash[:success] = "レシピを削除しました"
  end

  def confirm
    agent = Mechanize.new
    page = agent.get(params[:url])

    # application/ld+jsonでレシピ定義されている部分を取得
    if params[:url].include?("delishkitchen")
      js = page.search('script[type="application/ld+json"]')[1].text
    else
      js = page.at('script[type="application/ld+json"]').text
    end

    # JSON形式に変換して各パーツを取得
    elements = JSON[js]
    recipe = current_user.recipes.build

    #以下、レシピの各パーツを取得
    recipe.name = elements["name"]
    recipe.description = elements["description"]

    # URL取得
    if elements["mainEntityOfPage"].instance_of?(String)
      recipe.url = elements["mainEntityOfPage"]
    else
      recipe.url = elements["mainEntityOfPage"]["@id"]
    end

    # 何人分のレシピか取得
    if elements["recipeYield"].include?("servings")
      recipe.recipeYield = elements["recipeYield"].gsub!("servings","人分")
    else
      recipe.recipeYield = elements["recipeYield"]
    end

    # 調理時間取得（リファクタリングできそう、あとで取り組みたい）    
    if elements["totalTime"].present?
      if elements["totalTime"].last == "S"
        recipe.cooktime = elements["totalTime"].gsub!("PT", "").gsub!("S", "").to_i / 60
      elsif elements["cookTime"].last == "M"
        recipe.cooktime = elements["totalTime"].gsub!("PT", "").gsub!("M", "").to_i
      else
        recipe.cooktime = ""
      end
    elsif elements["cookTime"].present?
      if elements["cookTime"].last == "S"
        recipe.cooktime = elements["cookTime"].gsub!("PT", "").gsub!("S", "").to_i / 60
      elsif elements["cookTime"].last == "M"
        recipe.cooktime = elements["cookTime"].gsub!("PT", "").gsub!("M", "").to_i
      else
        recipe.cooktime = ""
      end
    else
      recipe.cooktime = ""
    end

    # イメージ画像取得
    if elements["image"].instance_of?(Array)
      recipe.grab_image(elements["image"].first)
    elsif elements["image"].instance_of?(Hash)
      recipe.grab_image(elements["image"]["url"])
    else
      recipe.grab_image(elements["image"])
    end
    
    # レシピ保存
    recipe.save

    # 材料とその分量取得
    elements["recipeIngredient"].each do |ingredient|
      ingredient = recipe.ingredients.build(
        name: ingredient.split(" ")[0],
        quantity_amount: ingredient.split(" ")[1])
      ingredient.save
    end

    # 作り方取得
    if elements["recipeInstructions"].instance_of?(String)
      how_to_steps = elements["recipeInstructions"].split("作り方")
      how_to_steps.each do |instruction|
        step = recipe.steps.build(body: instruction) 
        step.save
      end
    else
      elements["recipeInstructions"].each do |step|
        step = recipe.steps.build(body: step["text"])
        step.save
      end
    end

    # すべて保存できたら完了させてshowに飛ばす
    flash[:success] = "レシピを作成しました"
    redirect_to recipe

  end

  # 対象URLが入力したURLに含まれなかったらインポートしない
  def check_url
    input_url = params[:url]
    authorized_url = [
      "delishkitchen.tv/recipes",
      "cookpad.com/recipe",
      "kurashiru.com/recipes",
      "erecipe.woman.excite.co.jp/detail"]

    unless authorized_url.any? { |url| input_url.include?(url) }
      flash.now[:danger] = "このURLはインポートに対応していません"
      render :import
    end
  end

  # ログインしてなかったらログインページにリダイレクト
  def redirect_login
    unless logged_in?
      flash[:dangeer] = "ログインしてください"
      recirect_to login_url
    end
  end


  private

  def recipe_params
    params.require(:recipe).permit(
      :name,
      :description,
      :image,
      :url,
      :recipeYield,
      :cooktime,
      steps_attributes: [
        :id,
        :body,
        :_destroy,
      ],
      ingredients_attributes: [
        :id,
        :name,
        :quantity_amount,
        :_destroy,
      ]
    )
  end
end
