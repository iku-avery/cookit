class Api::V1::RecipesController < ApplicationController
  DEFAULT_MATCH_TYPE = 'all'

  def index
    recipes = ::Query::SearchRecipe.call(ingredient_ids: ingredient_ids, match_type: match_type)

    render json: recipes.as_json(include: :ingredients)
  end

  private

  def match_type
    params[:match_type] || DEFAULT_MATCH_TYPE
  end

  def ingredient_ids
    params[:ingredient_ids]&.split(',') || []
  end
end
