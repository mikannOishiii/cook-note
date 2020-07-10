class RecipesController < ApplicationController
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

  def confirm
    @recipe = current_user.recipes.build(recipe_params)

    # エラーがあれば編集画面へ戻す
    unless @recipe.valid?
      render 'new'
    end
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    
    if params[:back].present?
      render :new
      return
    end

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
