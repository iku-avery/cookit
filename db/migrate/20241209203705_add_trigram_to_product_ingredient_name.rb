class AddTrigramToProductIngredientName < ActiveRecord::Migration[7.0]
  def change
    add_index :product_ingredients, :name, using: :gin, opclass: :gin_trgm_ops, name: "index_product_ingredients_on_name_trigram"
  end
end
