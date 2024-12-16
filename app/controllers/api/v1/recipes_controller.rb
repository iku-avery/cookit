class Api::V1::RecipesController < ApplicationController
  DEFAULT_MATCH_TYPE = 'all'
  DEFAULT_PER_PAGE = 10

  def index
    result = ::Query::SearchRecipe.call(
      ingredient_ids: ingredient_ids,
      match_type: match_type,
      page: page,
      per_page: per_page
    )

    render json: {
      recipes: result[:recipes].as_json(include: :ingredients),
      total_count: result[:total_count],
      total_pages: result[:total_pages],
      current_page: result[:current_page]
    }
  end

  private

  def match_type
    params[:match_type] || DEFAULT_MATCH_TYPE
  end

  def ingredient_ids
    params[:ingredient_ids]&.split(',') || []
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || DEFAULT_PER_PAGE
  end
end
