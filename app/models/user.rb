class User < ActiveRecord::Base
  has_many :repos
  has_many :refreshes

  validates :github_username, presence: true
end
