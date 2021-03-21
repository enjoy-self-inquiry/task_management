FactoryBot.define do
  factory :user do
    name { "test1" }
    email { "test1@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { true }
  end

  factory :second_user, class: User do
    name { "test2" }
    email { "test2@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end

  factory :third_user, class: User do
    name { "test3" }
    email { "test3@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    admin { false }
  end
end
