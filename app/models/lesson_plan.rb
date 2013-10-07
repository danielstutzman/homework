class LessonPlan < ActiveRecord::Base
  has_many :exercises, order: :order_in_lesson

  validates :date,    presence: true
  validates :content, presence: true
  validates :topic,   presence: true
  validates :date,    uniqueness: true

  before_validation :parse_content_for_handout_and_topic
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
    self.create_exercises
  end

  def create_exercises!
    Exercise.transaction do
      self.exercises.each { |exercise| exercise.destroy }
      exercises = self.create_exercises
      exercises.each { |exercise| exercise.save! }
    end
  end

  def create_exercises
      in_exercise = false
      exercises = []
      exercise_num_indents = 0
      self.content.split(/\r?\n/).each_with_index do |line, line_num0|
        match = line.match(/^( *)([-+] )?(X([0-9]*) ?)?(.*)$/)

        num_indents = match[1].size
        if num_indents % 2 == 1
          errors.add :base, "Odd number of indents at line #{line_num0 + 1}"
        end

        if match[3]
          in_exercise = true
          exercise_num_indents = num_indents
          exercise = Exercise.new({
            lesson_plan_id: self.id,
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
      exercises
  end

  def content_as_html
    last_num_indents = 0
    exercise_num = 0

    lines = self.content.split(/\r?\n/).map do |line|

      line.gsub! /</, '&lt;'
      line.gsub! />/, '&gt;'
      line.gsub! /`(.*?)`/, '<code>\\1</code>'
      if line.include?('HANDOUT')
        line.gsub! /HANDOUT (https?:.*)$/,
          "<a target='_blank' href='\\1'>Handout</a>"
      else
        line.gsub! /(https?:\/\/[^\n ,]+)/,
          "<code><a target='_blank' href='\\1'>\\1</a></code>"
      end

      if match = line.match(/^\* (.*)$/)
        num_indents = 0
        line = '' # remove h1
      elsif match = line.match(/^\*\* (.*)$/)
        num_indents = 0
        line = "<h2>#{match[1]}</h2>" # convert ** to h2
      else
        match = line.match(/^( *)([-+] )?(X([0-9]*) ?)?(.*)$/)
        num_indents = match[1].size + (match[2] || '').size

        line = match[5]

        possible_class = ''
        possible_intro = ''
        if match[3]
          exercise_num += 1
          possible_class = "exercise"
          if match[4] != ''
            possible_intro = "<b><a href='/exercises/#{self.date.strftime('%m-%d')}/#{exercise_num}'>Exercise #{exercise_num} in #{match[4]}</a></b> "
          else
            possible_intro = "<b><a href='/exercises/#{self.date.strftime('%m-%d')}/#{exercise_num}'>Exercise #{exercise_num}</a></b> "
          end
        end

        if match[2] == '- '
          line = "<li class='#{possible_class}'>#{possible_intro}" + line
        elsif match[2] == '+ '
          line = "<li class='expandable #{possible_class}'>#{possible_intro}" +
            line
        elsif match[5] != '' # if not blank line
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
