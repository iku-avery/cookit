class IngredientParser
  class ParsingError < StandardError; end

    include Callable
  
    FRACTIONS = {
      "\u215b" => '1/8',
      "\u215c" => '3/8',
      "\u215d" => '5/8',
      "\u215e" => '7/8',
      "\u2159" => '1/6',
      "\u215a" => '5/6',
      "\u2155" => '1/5',
      "\u2156" => '2/5',
      "\u2157" => '3/5',
      "\u2158" => '4/5',
      "\u2153" => '1/3',
      "\u2154" => '2/3',
      "\u00bd" => '1/2',
      "\u00bc" => '1/4',
      "\u00be" => '3/4',
    }.freeze
  
    def initialize(ingredient_data)
      @ingredient_data = ingredient_data
    end
  
    def call
      sanitized_ingredient = sanitize_ingredient(@ingredient_data)
      ingredient = parse_with_eye_of_newt(sanitized_ingredient) || parse_with_ingreedy(sanitized_ingredient)
      ingredient
    end

    private
  
    def sanitize_ingredient(ingredient_data)
      ingredient_data.strip!
      ingredient_data.gsub!(/[™®']/, '') # Remove trademark symbols
      ingredient_data.gsub!(/\s+/, ' ') # Collapse multiple spaces
      FRACTIONS.each do |unicode, fraction|
        ingredient_data.gsub!(unicode, fraction) # Replace Unicode fractions
      end
      ingredient_data
    end
    
    def parse_with_eye_of_newt(ingredient_data)
      parsed_ingredient = EyeOfNewt.parse(ingredient_data)
      remark = parsed_ingredient.note || parsed_ingredient.style
      build_ingredient_dto(
        parsed_ingredient.name,
        parsed_ingredient.amount,
        parsed_ingredient.unit,
        remark,
        ingredient_data
      )
    rescue EyeOfNewt::InvalidIngredient => e
      puts "EyeOfNewt failed: #{e.message}."
    end
  
    def parse_with_ingreedy(ingredient_data)
      parsed_ingredient = Ingreedy.parse(ingredient_data)
      unit = parsed_ingredient[:unit] || 'pcs'
      build_ingredient_dto(
        parsed_ingredient[:ingredient],
        parsed_ingredient[:amount],
        unit.to_s,
        parsed_ingredient[:original_query]
      )
    rescue StandardError => e
      puts "Ingreedy failed: #{e.message}."
    end
  
    def build_ingredient_dto(name, amount, unit, remark=nil, full_text)
      ::DTO::Ingredient.new(
        name: name,
        amount: amount,
        unit: unit,
        remark: remark,
        full_text: full_text
      )
    end
    
    def log_failure(ingredient_data)
      puts "Failed to parse ingredient data: #{ingredient_data}"
    end
end
