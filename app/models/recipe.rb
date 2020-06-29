class Recipe < ApplicationRecord
  belongs_to  :user
  has_many    :ingredients,  dependent: :destroy
  has_many    :how_to_steps, dependent: :destroy

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  
  validates :user_id,     presence: true
  validates :name,        presence: true
  validates :description, length: { maximum: 140 }
  validates :url,   format: /\A#{URI::regexp(%w(http https))}\z/, allow_nil: true
  validates :image, format: /\A#{URI::regexp(%w(http https))}\z/, allow_nil: true
  validates :cooktime,      numericality: { only_integer: true }, allow_nil: true
end
