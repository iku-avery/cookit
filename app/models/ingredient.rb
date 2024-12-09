class Ingredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :product_ingredient

  validates :name, presence: true
end
