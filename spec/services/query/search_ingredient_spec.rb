require 'rails_helper'

RSpec.describe Query::SearchIngredient, type: :service do
  let!(:ingredient1) { create(:product_ingredient, name: "Potato") }
  let!(:ingredient2) { create(:product_ingredient, name: "Porcini") }
  let!(:ingredient3) { create(:product_ingredient, name: "Sprout") }

  describe '#call' do
    context 'when a query is provided' do
      let(:query) { "po" }
      subject { described_class.new(query).call }

      it 'returns ingredients that match the query' do
        result = subject

        expect(result).to include(ingredient1, ingredient2)
        expect(result).not_to include(ingredient3)
      end

      it 'orders ingredients by similarity to the query' do
        result = subject

        expect(result.first.name).to eq("Potato")
        expect(result.second.name).to eq("Porcini")
      end
    end

    context 'when no query is provided' do
      let(:query) { nil }
      subject { described_class.new(query).call }

      it 'returns an empty array' do
        result = subject
        expect(result).to eq([])
      end
    end
  end
end
