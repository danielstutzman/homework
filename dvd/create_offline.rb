require File.expand_path('../../config/environment', __FILE__)

LessonPlan.order(:date).each do |plan|
  path = "lessons/" + plan.date.strftime('%m-%d.html')
  File.open path, 'w' do |file|
    file.write "<html><head>\n"
    file.write "<title>#{plan.date.strftime('%m-%d')} #{plan.topic}</title>\n"
    file.write "<link href='../application.css' media='all' rel='stylesheet'>\n"
    file.write "<body>\n"
    file.write "<h1>#{plan.date.strftime('%b %d, 2013')}: #{plan.topic}</h1>\n"
    file.write plan.content_as_html
    file.write "</body></html>\n"
  end
end
