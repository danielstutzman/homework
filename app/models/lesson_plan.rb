class LessonPlan < ActiveRecord::Base
  has_many :exercises

  validates :date,    presence: true
  validates :content, presence: true
  validates :topic,   presence: true
  validates :date,    uniqueness: true

  def content_as_html
    last_num_indents = 0
    lines = self.content.split(/\r?\n/).map do |line|
      if match = line.match(/^\* (.*)$/)
        num_indents = 0
        line = '' # remove h1
      elsif match = line.match(/^\*\* (.*)$/)
        num_indents = 0
        line = "<h2>#{match[1]}</h2>" # convert ** to h2
      else
        match = line.match(/^( *)(- )?(.*)$/)
        num_indents = match[1].size + (match[2] || '').size

        line = match[3]

        if match[2] == '- '
          line = "<li>#{line}"
        else
          line = "<br>#{line}"
        end
      end

      if num_indents > last_num_indents
        last_num_indents += 2
        line = '<ul>' + line
      end

      while num_indents < last_num_indents
        last_num_indents -= 2
        line = '</ul>' + line
      end

      last_num_indents = num_indents

      line
    end
    lines.join("\n").html_safe
  end
end
