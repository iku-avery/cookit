namespace :recipes do
  desc "Import recipes from JSON file"
  task :import, [:limit, :batch] => :environment do |_t, args|
    file_path = Rails.root.join('lib', 'recipes-en.json')
    file = File.read(file_path)
    recipes = JSON.parse(file)

    DEFAULT_BATCH_SIZE = 500
    DEFAULT_LIMIT = recipes.size

    limit = args[:limit] ? args[:limit].to_i : DEFAULT_LIMIT
    batch_size = args[:batch] ? args[:batch].to_i : DEFAULT_BATCH_SIZE

    recipes.first(limit).each_with_index do |recipe, index|
      position = index + 1
      batch_number = (index / batch_size) + 1

      puts "(Batch #{batch_number}) (#{position}/#{limit}) Importing recipe: #{recipe['title']}"

      new_recipe = ::RecipeBuilder.call(recipe)

      if new_recipe.nil?
        puts "Failed to create or update recipe at index #{index}"
      else
        puts "Successfully processed recipe: #{recipe['title']}"
      end
    rescue StandardError => e
      puts "Error processing recipe at index #{index}: #{e.message}"
    end
  end
end
