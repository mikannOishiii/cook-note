class Recipe < ApplicationRecord
  belongs_to  :user
  has_many    :ingredients,  dependent: :destroy
  has_many    :steps,        dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :ingredients, allow_destroy: true
  accepts_nested_attributes_for :steps,       allow_destroy: true
  
  validates :user_id,     presence: true
  validates :name,        presence: true
  validates :description, length: { maximum: 140 }
  validates :url,   format: /\A#{URI::regexp(%w(http https))}\z/, allow_blank: true
  validates :cooktime,      numericality: { only_integer: true }, allow_blank: true

  def grab_image(url)
    require 'open-uri'
    downloaded_image = open(url)
    self.image.attach(io: downloaded_image  , filename: "foo.jpg")
  end

  def minTosec
    if self.last == "S"
      self.gsub!("PT", "").gsub!("S", "").to_i / 60
    else
      self.gsub!("PT", "").gsub!("M", "").to_i
    end
  end
end
