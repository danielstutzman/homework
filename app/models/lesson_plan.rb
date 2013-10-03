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
        match = line.match(/^( *)(- )?(X([0-9]+) ?)?(.*)$/)
        num_indents = match[1].size + (match[2] || '').size

        line = match[5]

        possible_class = ''
        possible_intro = ''
        if exercise_dir = match[4]
          possible_class = "class='exercise'"
          possible_intro = "<b>Exercise #{exercise_dir}</b> "
        end

        if match[2] == '- '
          line = "<li #{possible_class}>#{possible_intro}" + line
        else
          line = '<br>' + line
        end
      end

      while num_indents > last_num_indents
        line = '<ul>' + line
        last_num_indents += 2
      end

      while num_indents < last_num_indents
        line = '</ul>' + line
        last_num_indents -= 2
      end

      last_num_indents = num_indents

      line
    end

    while last_num_indents > 0
      last_num_indents -= 2
      lines += ['</ul>']
    end

    lines.join("\n").html_safe
  end
end
