class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @recipes = current_user.recipes.all
      render "recipes/index", recipes: @recipes
    end
  end
end
