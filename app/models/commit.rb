class Commit < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  belongs_to :exercise # optional

  validates :user_id,      presence: true
  validates :repo_id,      presence: true
  validates :sha,          presence: true
  validates :message,      presence: true
  validates :committed_at, presence: true
end
