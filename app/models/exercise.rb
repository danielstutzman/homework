class Exercise < ActiveRecord::Base
  belongs_to :lesson_plan
  has_many   :commits
  has_many   :refreshes

  validates :first_line, presence: true
  validates :content,    presence: true
  validates :order_in_lesson, presence: true
end
