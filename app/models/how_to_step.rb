class HowToStep < ApplicationRecord
  belongs_to :recipe

  validates :sort_order,  presence: true
  validates :body,        presence: true
  validates :recipe_id,   presence: true
end
