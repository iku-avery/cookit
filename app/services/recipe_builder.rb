class RecipeBuilder
  include Callable
  require 'uri'

  def initialize(data)
    @data = data
  end

  def call
    ActiveRecord::Base.transaction do
      title = @data['title'].capitalize
      image_url = decode_image_url(@data['image'])
      recipe = Recipe.create!(
        title: title,
        author: @data['author'],
        rating: @data['ratings'],
        category: @data['category'],
        cuisine: @data['cuisine'],
        cook_time: @data['cook_time'],
        prep_time: @data['prep_time'],
        image_url: image_url,
      )

      ingredients = IngredientsBuilder.call(@data['ingredients'], recipe.id)

      unless ingredients.present?
        puts "Ingredients not present, rolling back"
        raise ActiveRecord::Rollback, "Failed to persist Ingredients for Recipe"
      end

      recipe
    end
  rescue => e
    Rails.logger.error("RecipeBuilder failed: #{e.message}")
    nil
  end

  private

  def decode_image_url(original_url)
    uri = URI.parse(original_url)
    query_params = URI.decode_www_form(uri.query).to_h
    query_params['url']
  end

end
