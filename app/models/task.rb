class Task < ApplicationRecord
  validates :title,  presence: true, length: { maximum: 15 }
  validates :content, presence: true, length: { maximum: 150 }
  #validates :expire, presence: true
  #validates :progress, presence: true
  scope :search_title, -> (title){ where("title LIKE?","%#{title}%") }
  scope :search_progress, -> (progress) {where(progress: progress)}
  enum priority: { 高:0, 中:1, 低:2 }
end
