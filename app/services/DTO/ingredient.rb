module DTO
    class Ingredient
        attr_reader :amount, :unit, :name, :remark, :full_text
      
        def initialize(amount:, unit:, name:, remark:, full_text:)
            @amount = amount
            @unit = unit
            @name = name
            @remark = remark
            @full_text = full_text
        end
    end
end
