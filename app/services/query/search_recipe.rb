module Query
  class SearchRecipe
    include Callable

    def initialize(ingredient_ids:, match_type:, page:, per_page:)
      @ingredient_ids = ingredient_ids
      @match_type = match_type
      @page = page.to_i
      @per_page = per_page.to_i
    end

    def call
      return { recipes: [], total_count: 0, total_pages: 0, current_page: @page } if @ingredient_ids.blank?

      case @match_type
      when 'any'
        by_product_ingredients
      when 'all'
        containing_all_product_ingredients_ids
      else
        { recipes: [], total_count: 0, total_pages: 0, current_page: @page }
      end
    end

    private

    def by_product_ingredients
      recipes = Recipe
        .joins(:ingredients)
        .where(ingredients: { product_ingredient_id: @ingredient_ids })
        .distinct
        .preload(:ingredients) # preload ingredients if needed
        .order(:title)
        .select(
          'recipes.id',
          'recipes.title',
          'recipes.author',
          'recipes.rating',
          'recipes.category',
          'recipes.cuisine',
          'recipes.cook_time',
          'recipes.prep_time',
          'recipes.image_url'
        )
        .page(@page).per(@per_page)

      # Pagination metadata
      {
        recipes: recipes,
        total_count: recipes.total_count,
        total_pages: recipes.total_pages,
        current_page: recipes.current_page
      }
    end

    def containing_all_product_ingredients_ids
      recipes = Recipe
        .joins(:ingredients)
        .where(ingredients: { product_ingredient_id: @ingredient_ids })
        .group('recipes.id')
        .having('COUNT(DISTINCT ingredients.product_ingredient_id) = ?', @ingredient_ids.size)
        .select(
          'recipes.id',
          'recipes.title',
          'recipes.author',
          'recipes.rating',
          'recipes.category',
          'recipes.cuisine',
          'recipes.cook_time',
          'recipes.prep_time',
          'recipes.image_url'
        )
        .order('recipes.title ASC')
        .preload(:ingredients)
        .page(@page).per(@per_page)

      # Pagination metadata
      {
        recipes: recipes,
        total_count: recipes.total_count,
        total_pages: recipes.total_pages,
        current_page: recipes.current_page
      }
    end
  end
end
