class CreateLessonPlans < ActiveRecord::Migration
  def change
    create_table :lesson_plans do |t|
      t.date   :date,        null: false
      t.text   :content,     null: false
      t.string :topic,       null: false
      t.string :handout_url, null: true

      t.timestamps
    end
  end
end
