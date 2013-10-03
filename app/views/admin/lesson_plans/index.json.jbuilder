json.array!(@lesson_plans) do |lesson_plan|
  json.extract! lesson_plan, :date, :content, :topic, :handout_url
  json.url lesson_plan_url(lesson_plan, format: :json)
end
