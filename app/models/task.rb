class Task < ApplicationRecord
  belongs_to :user
  validates :title,  presence: true, length: { maximum: 15 }
  validates :content, presence: true, length: { maximum: 150 }
  #validates :expire, presence: true
  #validates :progress, presence: true

  has_many :labellings, dependent: :destroy
  has_many :labels, through: :labellings, source: :label
  accepts_nested_attributes_for :labels, allow_destroy: true

  scope :search_title, -> (title){ where("title LIKE?","%#{title}%") }
  scope :search_progress, -> (progress) {where(progress: progress)}
  enum priority: { 高:0, 中:1, 低:2 }
end
