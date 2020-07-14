class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
    @categories = Category.all
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = "カテゴリを作成しました"
      redirect_to new_category_url
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
    @categories = Category.all
  end

  def update
    @category = Category.find(params[:id])
    
    if @category.update(category_params)
      flash[:success] = "カテゴリを更新しました"
      redirect_to new_category_url
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "レシピを削除しました"
    redirect_to new_category_url
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
