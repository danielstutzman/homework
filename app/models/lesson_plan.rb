class LessonPlan < ActiveRecord::Base
  has_many :exercises, order: :order_in_lesson

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
    Exercise.transaction do
      self.exercises.each { |exercise| exercise.destroy }

      in_exercise = false
      exercises = []
      exercise_num_indents = 0
      self.content.split(/\r?\n/).each_with_index do |line, line_num0|
        match = line.match(/^( *)(- )?(X([0-9]*) ?)?(.*)$/)

        num_indents = match[1].size

        if match[3]
          in_exercise = true
          exercise_num_indents = num_indents
          exercise = Exercise.new({
            lesson_plan: self,
            exercise_dir: (match[4] == '') ? nil : match[4],
            first_line: match[5],
            content: match[5],
            order_in_lesson: exercises.size + 1,
          })
          if exercise.first_line == nil || exercise.first_line.strip == ''
            errors.add :base,
              "Exercise is missing description at line #{line_num0 + 1}"
          end
          exercises.push exercise
        elsif num_indents <= exercise_num_indents
          in_exercise = false
        elsif in_exercise
          line = ' ' * (num_indents - exercise_num_indents)
          line += match[2] if match[2] && num_indents > exercise_num_indents
          line += match[5]
          exercises.last.content += "\n" + line
        end
      end
      exercises.each { |exercise| exercise.save! }
      return true
    end
    return false
  end

  def content_as_html
    last_num_indents = 0
    exercise_num = 0

    lines = self.content.split(/\r?\n/).map do |line|
      if match = line.match(/^\* (.*)$/)
        num_indents = 0
        line = '' # remove h1
      elsif match = line.match(/^\*\* (.*)$/)
        num_indents = 0
        line = "<h2>#{match[1]}</h2>" # convert ** to h2
      else
        match = line.match(/^( *)(- )?(X([0-9]*) ?)?(.*)$/)
        num_indents = match[1].size + (match[2] || '').size

        line = match[5]

        possible_class = ''
        possible_intro = ''
        if match[3]
          exercise_num += 1
          possible_class = "class='exercise'"
          if match[4] != ''
            possible_intro = "<b>Exercise #{exercise_num} in #{match[4]}</b> "
          else
            possible_intro = "<b>Exercise #{exercise_num}</b> "
          end
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

      line.gsub! /`(.*?)`/, '<code>\\1</code>'
      line.gsub! /(https?:\/\/[^ ,]+)/, "<a target='_new' href='\\1'>\\1</a>"

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
