class RecipeCategoryRelation < ApplicationRecord
  belongs_to :recipe
  belongs_to :category

  validates  :recipe_id,   presence: true
  validates  :category_id, presence: true
end
