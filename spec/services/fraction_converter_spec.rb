require 'rails_helper'

RSpec.describe FractionConverter do
  describe '.convert_to_decimal' do
    it 'converts fraction symbols to decimals' do
      expect(FractionConverter.convert_to_decimal("½")).to eq(0.5)
      expect(FractionConverter.convert_to_decimal("¼")).to eq(0.25)
      expect(FractionConverter.convert_to_decimal("¾")).to eq(0.75)
    end

    it 'converts simple fraction strings to decimals' do
      expect(FractionConverter.convert_to_decimal("1/2")).to eq(0.5)
      expect(FractionConverter.convert_to_decimal("3/4")).to eq(0.75)
      expect(FractionConverter.convert_to_decimal("2/5")).to eq(0.4)
    end

    it 'converts mixed numbers to decimals' do
      expect(FractionConverter.convert_to_decimal("1 1/2")).to eq(1.5)
      expect(FractionConverter.convert_to_decimal("2 3/4")).to eq(2.75)
      expect(FractionConverter.convert_to_decimal("3 2/5")).to eq(3.4)
    end

    it 'handles whole numbers as input' do
      expect(FractionConverter.convert_to_decimal("2")).to eq(2.0)
      expect(FractionConverter.convert_to_decimal("10")).to eq(10.0)
    end

    it 'handles numeric input directly' do
      expect(FractionConverter.convert_to_decimal(2)).to eq(2.0)
      expect(FractionConverter.convert_to_decimal(1.5)).to eq(1.5)
    end
  end
end
