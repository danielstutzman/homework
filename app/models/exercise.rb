class Exercise < ActiveRecord::Base
  validates :dir_name, presence: true
end
