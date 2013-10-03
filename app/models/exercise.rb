class Exercise < ActiveRecord::Base
  belongs_to :lesson_plan
  has_many   :commits
  has_many   :refreshes

  validates :lesson_plan_id, presence: true
  validates :dir,            presence: true
end
