class Category < ApplicationRecord
  belongs_to :user
  has_many   :recipes, through: :recipe_category_relations
  has_many   :recipe_category_relations, dependent: :destroy

  validates  :name, presence: true,
                    length: { maximum: 50 },
                    uniqueness: { case_sensitive: true, scope: :user_id } 
end
