module Query
  class SearchRecipe
    include Callable

    def initialize(ingredient_ids:, match_type:)
      @ingredient_ids = ingredient_ids
      @match_type = match_type
    end

    def call
      return [] if @ingredient_ids.blank?

      case @match_type
      when 'any'
        by_product_ingredients
      when 'all'
        containing_all_product_ingredients_ids
      else
        []
      end
    end

    private

    def by_product_ingredients
      Recipe
        .joins(:ingredients)
        .where(ingredients: { product_ingredient_id: @ingredient_ids })
        .group('recipes.id')
        .order(:title)
    end

    def containing_all_product_ingredients_ids
      Recipe
        .joins(:ingredients)
        .where(ingredients: { product_ingredient_id: @ingredient_ids })
        .group('recipes.id')
        .having('COUNT(DISTINCT ingredients.product_ingredient_id) = ?', @ingredient_ids.size)
        .select('recipes.*, COUNT(DISTINCT ingredients.product_ingredient_id) as matched_ingredients')
        .order(:title)
    end
  end
end
