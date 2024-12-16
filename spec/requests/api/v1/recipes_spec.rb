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

    # Default pagination values
    let(:page) { 1 }
    let(:per_page) { 10 }

    context 'when match_type is "any"' do
      it 'returns recipes with any of the given ingredient_ids' do
        get '/api/v1/recipes', params: { ingredient_ids: product_ingredient1.id, match_type: 'any', page: page, per_page: per_page }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body['recipes'].map { |recipe| recipe['title'] }  # Corrected this line

        expect(titles).to include('Tomato Salad')
        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end

    context 'when match_type is "all"' do
      it 'returns recipes with all of the given ingredient_ids' do
        get '/api/v1/recipes', params: { ingredient_ids: "#{product_ingredient1.id},#{product_ingredient2.id}", match_type: 'all', page: page, per_page: per_page }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body['recipes'].map { |recipe| recipe['title'] }  # Corrected this line

        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Tomato Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end

    context 'when ingredient_ids are blank' do
      it 'returns an empty array' do
        get '/api/v1/recipes', params: { page: page, per_page: per_page }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        # Updated expectation for empty response structure
        expect(body['recipes']).to eq([])
        expect(body['current_page']).to eq(1)
        expect(body['total_count']).to eq(0)
        expect(body['total_pages']).to eq(0)
      end
    end

    context 'when match_type is invalid' do
      it 'returns an empty array' do
        get '/api/v1/recipes', params: { ingredient_ids: product_ingredient1.id, match_type: 'invalid', page: page, per_page: per_page }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        # Updated expectation for empty response structure
        expect(body['recipes']).to eq([])
        expect(body['current_page']).to eq(1)
        expect(body['total_count']).to eq(0)
        expect(body['total_pages']).to eq(0)
      end
    end

    context 'when match_type is empty and ingredient_ids are present' do
      it 'defaults to match_type "all"' do
        get '/api/v1/recipes', params: { ingredient_ids: "#{product_ingredient1.id},#{product_ingredient2.id}", page: page, per_page: per_page }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        titles = body['recipes'].map { |recipe| recipe['title'] }  # Corrected this line

        expect(titles).to include('Tomato Lettuce Salad')
        expect(titles).not_to include('Tomato Salad')
        expect(titles).not_to include('Lettuce Salad')
      end
    end
  end
end
