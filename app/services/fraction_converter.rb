require 'fractional'

class FractionConverter
  def self.convert_to_fraction(decimal)
    if decimal == decimal.to_i
      return decimal.to_i.to_s
    end

    fraction = Fractional.new(decimal, to_human: true).to_s

    if fraction.include?('/')
      whole_number = decimal.to_i
      fractional_part = Fractional.new(decimal - whole_number, to_human: true).to_s
      if whole_number > 0
        return "#{whole_number} #{fractional_part}"
      else
        return fractional_part
      end
    else
      return fraction
    end
  end
end
