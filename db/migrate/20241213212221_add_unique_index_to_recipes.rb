class AddUniqueIndexToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_index :recipes, [:title, :author], unique: true
  end
end
