class Recipe < ApplicationRecord
    has_many :ingredients, dependent: :destroy
    has_many :product_ingredients, through: :ingredients
end
