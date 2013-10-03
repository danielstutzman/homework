class LessonPlan < ActiveRecord::Base
  validates :date,    presence: true
  validates :content, presence: true
  validates :topic,   presence: true
end
