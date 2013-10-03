class Repo < ActiveRecord::Base
  belongs_to :user
  has_many   :repos
  has_many   :refreshes
  has_many   :commits

  validates :user_id,   presence: true
  validates :name,      presence: true
  validates :https_url, presence: true
end
