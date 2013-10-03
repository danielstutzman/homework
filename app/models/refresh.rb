class Refresh < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  belongs_to :exercise # optional

  validates :user_id,     presence: true
  validates :repo_id,     presence: true
  validates :logged_at,   presence: true
end
