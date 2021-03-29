FactoryBot.define do
  factory :label do
    name { "0番目のラベル" }
  end
  factory :second_label, class: Label do
    name { "1番目のラベル" }
  end
  factory :third_label, class: Label do
    name { "2番目のラベル" }
  end
end
