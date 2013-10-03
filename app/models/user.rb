class User < ActiveRecord::Base
  validates :github_username, presence: true
end
