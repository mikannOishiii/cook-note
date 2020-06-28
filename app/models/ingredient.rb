class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :name,              presence: true
  validates :quantity_amount,   presence: true
end
