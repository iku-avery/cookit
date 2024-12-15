
class FractionConverter
  FRACTIONS = {
    "\u00bd" => 0.5,
    "\u00bc" => 0.25,
    "\u00be" => 0.75,
    "\u2153" => 1.0/3.0,
    "\u2154" => 2.0/3.0,
    "\u2155" => 1.0/5.0,
    "\u2156" => 2.0/5.0,
    "\u2157" => 3.0/5.0,
    "\u2158" => 4.0/5.0,
    "\u2159" => 1.0/6.0,
    "\u215a" => 5.0/6.0,
    "\u215b" => 1.0/8.0,
    "\u215c" => 3.0/8.0,
    "\u215d" => 5.0/8.0,
    "\u215e" => 7.0/8.0,
    "\u215f" => 1.0/7.0
  }.freeze

  def self.convert_to_decimal(input)
    return input.to_f if input.is_a?(Numeric)

    if FRACTIONS.key?(input)
      return FRACTIONS[input]
    end

    # Check if input is a complex fraction (e.g., "1 1/2")
    if input.match(/(\d+)\s+(\d+)\/(\d+)/)
      whole_number = $1.to_i
      numerator = $2.to_i
      denominator = $3.to_i
      return whole_number + (numerator.to_f / denominator)
    end

    # Check if input is a simple fraction (e.g., "1/2")
    if input.match(/(\d+)\/(\d+)/)
      numerator = $1.to_i
      denominator = $2.to_i
      return numerator.to_f / denominator
    end

    input.to_f
  end
end