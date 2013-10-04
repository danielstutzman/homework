class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises, id: false do |t|
      t.integer :id,             null: false # not auto-numbered
      t.integer :lesson_plan_id, null: false
      t.string  :first_line,     null: false
      t.text    :content,        null: true

      t.timestamps
    end

    add_index :exercises, :id, unique: true
    add_index :exercises, :lesson_plan_id
  end
end
