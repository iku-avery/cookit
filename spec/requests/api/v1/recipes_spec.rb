require 'rails_helper'

RSpec.describe Api::V1::RecipesController, type: :request do
  describe 'GET /api/v1/recipes' do
    let!(:product_ingredient1) { create(:product_ingredient, name: 'Tomato') }
    let!(:product_ingredient2) { create(:product_ingredient, name: 'Lettuce') }

    let!(:recipe1) { create(:recipe, title: 'Tomato Salad') }
    let!(:recipe2) { create(:recipe, title: 'Lettuce Salad') }
    let!(:recipe3) { create(:recipe, title: 'Tomato Lettuce Salad') }

    let!(:ingredient1) { create(:ingredient, product_ingredient: product_ingredient1, recipe: recipe1) }
    let!(:ingredient2) { create(:ingredient, product_ingredient: product_ingredient2, recipe: recipe2) }
    let!(:ingredient3) { create(:ingredient, product_ingredient: product_ingredient1, recipe: recipe3) }
    let!(:ingredient4) { create(:ingredient, product_ingredient: product_ingredient2, recipe: recipe3) }

    context 'when match_type is "any"' do
      it 'returns recipes with any of the given ingredient_ids' do
        get '/api/v1/recipes', params: { ingredient_ids: product_ingredient1.id, match_type: 'any' }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body.map { |recipe| recipe['title'] }

        expect(titles).to include('Tomato Salad')
        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end

    context 'when match_type is "all"' do
      it 'returns recipes with all of the given ingredient_ids' do
        get '/api/v1/recipes', params: { ingredient_ids: "#{product_ingredient1.id},#{product_ingredient2.id}", match_type: 'all' }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body.map { |recipe| recipe['title'] }

        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Tomato Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end

    context 'when ingredient_ids are blank' do
      it 'returns an empty array' do
        get '/api/v1/recipes'

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        expect(body).to eq([])
      end
    end

    context 'when match_type is invalid' do
      it 'returns an empty array' do
        get '/api/v1/recipes', params: { ingredient_ids: product_ingredient1.id, match_type: 'invalid' }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        expect(body).to eq([])
      end
    end

    context 'when match_type is empty and ingredient_ids are present' do
      it 'defaults to match_type "all"' do
        get '/api/v1/recipes', params: { ingredient_ids: "#{product_ingredient1.id},#{product_ingredient2.id}" }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body.map { |recipe| recipe['title'] }

        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Tomato Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end
  end
end
