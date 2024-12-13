class Api::V1::ProductIngredientsController < ApplicationController
  def index
    @product_ingredients = ::Query::SearchIngredient.call(query: query_param)

    render json: @product_ingredients
  end

  private

  def query_param
    params[:query].to_s.strip
  end
end
