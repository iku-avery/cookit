require 'rails_helper'

RSpec.describe FractionConverter do
  describe '.convert_to_fraction' do
    it 'converts decimals to the closest known fraction' do
      expect(FractionConverter.convert_to_fraction(0.5)).to eq("1/2")
      expect(FractionConverter.convert_to_fraction(0.25)).to eq("1/4")
      expect(FractionConverter.convert_to_fraction(0.75)).to eq("3/4")
      expect(FractionConverter.convert_to_fraction(1.0)).to eq("1")
    end

    it 'converts decimal approximations to fractions' do
      expect(FractionConverter.convert_to_fraction(0.3333333333333333)).to eq("1/3")
      expect(FractionConverter.convert_to_fraction(0.6666666666666666)).to eq("2/3")
      expect(FractionConverter.convert_to_fraction(0.4)).to eq("2/5")
      expect(FractionConverter.convert_to_fraction(0.6)).to eq("3/5")
    end

    it 'handles mixed decimal numbers and returns the best matching fraction' do
      expect(FractionConverter.convert_to_fraction(1.5)).to eq("1 1/2")
      expect(FractionConverter.convert_to_fraction(2.75)).to eq("2 3/4")
    end

    it 'handles very small decimals' do
      expect(FractionConverter.convert_to_fraction(0.1)).to eq("1/10")
      expect(FractionConverter.convert_to_fraction(0.125)).to eq("1/8")
    end

    it 'handles decimals close to 1 and returns the best matching fraction' do
      expect(FractionConverter.convert_to_fraction(0.999999)).to eq("1")
      expect(FractionConverter.convert_to_fraction(0.875)).to eq("7/8")
    end

    it 'returns the best matching fraction when there is no exact match' do
      expect(FractionConverter.convert_to_fraction(0.15)).to eq("1/7")
    end

    it 'returns "1" for whole numbers' do
      expect(FractionConverter.convert_to_fraction(3.0)).to eq("3")
      expect(FractionConverter.convert_to_fraction(10.0)).to eq("10")
    end
  end
end
