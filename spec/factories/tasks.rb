FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    expire { '2021-12-31' }
    progress { '未着手'}
  end
end
