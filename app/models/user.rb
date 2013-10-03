class User < ActiveRecord::Base
  has_many :repos
  has_many :refreshes
  has_many :commits

  validates :github_username, presence: true
end
