class Recipe < ApplicationRecord
    has_many :ingredients, dependent: :destroy
    has_many :product_ingredients, through: :ingredients

    validates :title, uniqueness: { scope: :author, message: "has already been added by this author" }
end
