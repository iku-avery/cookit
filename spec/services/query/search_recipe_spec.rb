require 'rails_helper'

RSpec.describe Query::SearchRecipe, type: :service do
  let!(:product_ingredient1) { create(:product_ingredient, name: 'Tomato') }
  let!(:product_ingredient2) { create(:product_ingredient, name: 'Lettuce') }
  let!(:recipe1) { create(:recipe, title: 'Tomato Salad') }
  let!(:recipe2) { create(:recipe, title: 'Lettuce Wrap') }
  let!(:recipe3) { create(:recipe, title: 'Tomato Lettuce Salad') }

  let!(:ingredient1) { create(:ingredient, recipe: recipe1, product_ingredient: product_ingredient1) }
  let!(:ingredient2) { create(:ingredient, recipe: recipe2, product_ingredient: product_ingredient2) }
  let!(:ingredient3) { create(:ingredient, recipe: recipe3, product_ingredient: product_ingredient1) }
  let!(:ingredient4) { create(:ingredient, recipe: recipe3, product_ingredient: product_ingredient2) }

  describe '#call' do
    context 'when match_type is "any"' do
      it 'returns recipes with any of the given ingredient_ids' do
        ingredient_ids = [product_ingredient1.id]

        result = Query::SearchRecipe.call(ingredient_ids: ingredient_ids, match_type: 'any')

        expect(result).to include(recipe1, recipe3)
        expect(result).not_to include(recipe2)
      end
    end

    context 'when match_type is "all"' do
      it 'returns recipes with all of the given ingredient_ids' do
        ingredient_ids = [product_ingredient1.id, product_ingredient2.id]

        result = Query::SearchRecipe.call(ingredient_ids: ingredient_ids, match_type: 'all')

        expect(result).to include(recipe3)

        expect(result).not_to include(recipe1, recipe2)
      end
    end

    context 'when ingredient_ids are blank' do
      it 'returns an empty array' do
        result = Query::SearchRecipe.call(ingredient_ids: [], match_type: 'any')
        expect(result).to eq([])
      end
    end

    context 'when an invalid match_type is provided' do
      it 'returns an empty array' do
        result = Query::SearchRecipe.call(ingredient_ids: [product_ingredient1.id], match_type: 'invalid')
        expect(result).to eq([])
      end
    end
  end
end
