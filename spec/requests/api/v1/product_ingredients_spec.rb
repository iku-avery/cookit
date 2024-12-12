require 'rails_helper'

RSpec.describe "Api::V1::ProductIngredients", type: :request do
  let!(:ingredient_1) { create(:product_ingredient, name: "Tomato") }
  let!(:ingredient_2) { create(:product_ingredient, name: "Tomme") }
  let!(:ingredient_3) { create(:product_ingredient, name: "Potato") }

  describe "GET /index" do
    context "with a valid query" do
      it "returns matching ingredients ordered by similarity" do
        allow(::Query::SearchIngredient).to receive(:new).and_call_original

        get "/api/v1/product_ingredients", params: { query: "tom" }

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)

        expect(result.size).to eq(2)
        expect(result.map { |i| i["name"] }).to include("Tomato", "Tomme")

        expect(::Query::SearchIngredient).to have_received(:new).with("tom")
      end
    end

    context "with an empty query" do
      it "returns an empty array" do
        get "/api/v1/product_ingredients", params: { query: "" }

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)

        expect(result).to eq([])
      end
    end

    context "without a query param" do
      it "returns an empty array" do
        get "/api/v1/product_ingredients"

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)

        expect(result).to eq([])
      end
    end
  end
end
