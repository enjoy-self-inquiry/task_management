class Task < ApplicationRecord
  validates :title,  presence: true, length: { maximum: 15 }
  validates :content, presence: true, length: { maximum: 150 }
end
