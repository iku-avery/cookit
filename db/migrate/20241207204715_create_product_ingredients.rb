class CreateProductIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :product_ingredients do |t|
      t.string :name

      t.timestamps
    end
    add_index :product_ingredients, :name, unique: true
  end
end
