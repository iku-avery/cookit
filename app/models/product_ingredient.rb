class ProductIngredient < ApplicationRecord
    has_many :ingredients
    has_many :recipes, through: :ingredients

    validates :name, uniqueness: true, presence: true
end
