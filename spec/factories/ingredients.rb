FactoryBot.define do
  factory :ingredient do
    name { "MyString" }
    amount { "9.99" }
    unit { "MyString" }
    remark { "MyString" }
    full_text { "MyString" }
    recipe { nil }
    product_ingredient { nil }
  end
end
