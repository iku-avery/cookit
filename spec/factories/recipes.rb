FactoryBot.define do
  factory :recipe do
    title { "MyString" }
    author { "MyString" }
    rating { "9.99" }
    category { "MyString" }
    cuisine { "MyString" }
    cook_time { 1 }
    prep_time { 1 }
    image_url { "https://myurl.com" }
  end
end
