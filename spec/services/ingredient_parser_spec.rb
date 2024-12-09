require 'rails_helper'

RSpec.describe IngredientParser do
  describe '#call' do
    let(:ingredient_data) { "1 ½ cups of butter, melted" }
    let(:parser) { described_class.new(ingredient_data) }

    it 'parses ingredient data' do
      result = parser.call

      expect(result.name).to eq('butter')
      expect(result.amount).to eq(1.5)
      expect(result.unit).to eq('cups')
      expect(result.remark).to eq('melted')
      expect(result.full_text).to eq('1 1/2 cups of butter, melted')
    end

    it 'handles special characters and multiple spaces' do
      invalid_data = "  1/2 cup™ of  flour®   "
      parser = described_class.new(invalid_data)

      result = parser.call

      expect(result.name).to eq('flour')
      expect(result.amount).to eq(0.5)
      expect(result.unit).to eq('cups')
      expect(result.full_text).to eq('1/2 cup of flour')
    end

    it 'parses ingredient data with a decimal amount' do
        decimal_data = "0.75 liters of milk"
        parser = described_class.new(decimal_data)

  
        result = parser.call
  
        expect(result.name).to eq('milk')
        expect(result.amount).to eq(0.75)
        expect(result.unit).to eq('l')
        expect(result.full_text).to eq('0.75 liters of milk')
      end
  
      it 'parses ingredient data with weight in grams' do
        grams_data = "250 grams of butter"
        parser = described_class.new(grams_data)
  
        result = parser.call
  
        expect(result.name).to eq('butter')
        expect(result.amount).to eq(250.0)
        expect(result.unit).to eq('g')
        expect(result.full_text).to eq('250 grams of butter')
    end
  end

  context 'when the ingredient has extra descriptive information' do
    let(:ingredient_data) { "1 Granny Smith apple - peeled, cored and coarsely shredded" }
    let(:parser) { described_class.new(ingredient_data) }

    it 'parses the ingredient data correctly' do
      result = parser.call

      expect(result.name).to eq('Granny Smith apple - peeled, cored and coarsely shredded')
      expect(result.amount).to eq(1)
      expect(result.unit).to eq('pcs')
      expect(result.remark).to be_nil
      expect(result.full_text).to eq('1 Granny Smith apple - peeled, cored and coarsely shredded')
    end
  end

  # Test for a can or bottle ingredient with a specified container unit
  context 'when the ingredient is in a can or bottle' do
    let(:ingredient_data) { "1 (12 fluid ounce) can or bottle beer" }
    let(:parser) { described_class.new(ingredient_data) }

    it 'parses the ingredient data correctly' do
      result = parser.call

      expect(result.name).to eq('can or bottle beer')
      expect(result.amount).to eq(1)
      expect(result.unit).to eq('pcs')
      expect(result.remark).to be_nil
      expect(result.full_text).to eq('1 (12 fluid ounce) can or bottle beer')
    end
  end

  context 'when the ingredient is marked as pre-cooked' do
    let(:ingredient_data) { "2 cups pre-cooked white corn meal (such as P.A.N.)" }
    let(:parser) { described_class.new(ingredient_data) }

    it 'parses the ingredient data correctly' do
      result = parser.call

      expect(result.name).to eq('pre-cooked white corn meal (such as P.A.N.)')
      expect(result.amount).to eq(2)
      expect(result.unit).to eq('cup')
      expect(result.remark).to be_nil
      expect(result.full_text).to eq('2 cups pre-cooked white corn meal (such as P.A.N.)')
    end
  end
end
