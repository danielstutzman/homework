json.array!(@exercises) do |exercise|
  json.extract! exercise, :dir_name
  json.url exercise_url(exercise, format: :json)
end
