class LessonPlan < ActiveRecord::Base
  has_many :exercises

  validates :date,    presence: true
  validates :content, presence: true
  validates :topic,   presence: true
  validates :date,    uniqueness: true

  before_save :parse_content_for_handout_and_topic
  validate :exercises_can_be_created

  def parse_content_for_handout_and_topic
    self.content.split(/\r?\n/).each_with_index do |line, line_num0|
      # For example, if content has "* 10-07: HTML", set topic to "HTML"
      if match = line.match(/^\* (.*)$/)
        topic = match[1]
        topic = topic[(topic.index(':') + 2)..-1] if topic.include?(':')
        self.topic = topic
      end

      if match = line.match(/^HANDOUT (https?:.*)$/)
        self.handout_url = match[1]
      end
    end
  end

  def exercises_can_be_created
    LessonPlan.transaction do
      exercise_num_to_lines = {}
      exercise_num_to_line_num = {}
      exercise_num = nil
      exercise_num_indents = 0
      self.content.split(/\r?\n/).each_with_index do |line, line_num0|
        match = line.match(/^( *)(- )?(X([0-9]+) ?)?(.*)$/)

        num_indents = match[1].size

        if match[4]
          exercise_num = match[4].to_i
          exercise_num_indents = num_indents # 2 for "- " bullet
          exercise_num_to_lines[exercise_num] = []
          exercise_num_to_line_num[exercise_num] = line_num0 + 1
        elsif num_indents <= exercise_num_indents
          exercise_num = nil
        end

        if exercise_num
          line = ' ' * (num_indents - exercise_num_indents)
          line += match[2] if match[2] && num_indents > exercise_num_indents
          line += match[5]
          exercise_num_to_lines[exercise_num].push line
        end
      end

      self.exercises.each { |exercise| exercise.destroy }

      exercise_num_to_lines.each do |exercise_num, lines|
        if lines.first == nil || lines.first.strip == ''
          line_num = exercise_num_to_line_num[exercise_num]
          errors.add :base,
            "Exercise is missing description at line #{line_num}"
          raise ActiveRecord::Rollback
        end

        Exercise.create!({
          id: exercise_num,
          lesson_plan: self,
          first_line: lines.first,
          content: lines.join("\n"),
        })
      end
      return true
    end
    return false
  end

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
