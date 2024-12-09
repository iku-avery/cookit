class IngredientsBuilder
  include Callable

  def initialize(data, recipe_id)
    @data = data
    @recipe_id = recipe_id
  end

  def call
    ActiveRecord::Base.transaction do
      @data.each do |ingredient_data|
        parsed_ingredient = ::IngredientParser.call(ingredient_data)
        raise ActiveRecord::Rollback, "Failed to parse ingredient: #{ingredient_data}" unless parsed_ingredient

        ingredient_name = parsed_ingredient.name.capitalize
        product_ingredient = ProductIngredient.find_or_create_by!(name: ingredient_name)

        ingredient = Ingredient.new(
          name: ingredient_name,
          amount: parsed_ingredient.amount,
          unit: parsed_ingredient.unit,
          remark: parsed_ingredient.remark,
          full_text: parsed_ingredient.full_text,
          recipe_id: @recipe_id,
          product_ingredient: product_ingredient
        )

        unless ingredient.save
          raise ActiveRecord::Rollback, "Failed to persist ingredient: #{ingredient.errors.full_messages.join(', ')}"
        end
      end
    end
  rescue => e
    Rails.logger.error("IngredientsBuilder failed: #{e.message}")
    raise e # Propagate the error to the RecipeBuilder
  end
end
