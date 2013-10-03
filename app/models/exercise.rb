class Exercise < ActiveRecord::Base
  belongs_to :lesson_plan

  validates :lesson_plan_id, presence: true
  validates :dir,            presence: true
end
