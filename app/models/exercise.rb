class Exercise < ActiveRecord::Base
  belongs_to :lesson_plan
  has_many   :commits
  has_many   :refreshes

  validates :first_line, presence: true
  validates :content,    presence: true
  validates :order_in_lesson, presence: true

  def content_as_html
    self.content.gsub(/`(.*?)`/, '<code>\\1</code>').gsub(/(https?:\/\/[^\n ,]+)/, "<code><a target='_new' href='\\1'>\\1</a></code>").html_safe
  end
end
