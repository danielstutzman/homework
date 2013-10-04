class Exercise < ActiveRecord::Base
  self.primary_key = :id

  belongs_to :lesson_plan
  has_many   :commits
  has_many   :refreshes

  validates :id, presence: true
  validates :id, uniqueness: true
  validates :first_line, presence: true
end
