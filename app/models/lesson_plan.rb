class LessonPlan < ActiveRecord::Base
  has_many :exercises

  validates :date,    presence: true
  validates :content, presence: true
  validates :topic,   presence: true
  validates :date,    uniqueness: true
end
