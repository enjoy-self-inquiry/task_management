FactoryBot.define do
  factory :task do
    title { 'task1' }
    content { 'task1_content' }
    expire { '2021-12-31' }
    priority { '高' }
    progress { '着手中'}
    association :user
  end

  factory :second_task, class: Task do
    title { 'task2' }
    content { 'task2_content' }
    expire { '2021-12-30'}
    priority { '中' }
    progress { '着手中' }
    association :user
  end

  factory :third_task, class: Task do
    title { 'task3' }
    content { 'task3_content' }
    expire { '2021-12-29' }
    priority { '低' }
    progress { '着手中' }
    association :user
  end

  factory :fourth_task, class: Task do
    title { 'task4' }
    content { 'task4_content' }
    expire { '2021-12-30' }
    priority { '中' }
    progress { '完了' }
    association :user
  end
end
