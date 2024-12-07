class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.decimal :amount
      t.string :unit
      t.string :remark
      t.string :full_text
      t.references :recipe, null: false, foreign_key: true
      t.references :product_ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
