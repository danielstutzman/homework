class ArbitraryExerciseIds < ActiveRecord::Migration
  def up
    drop_table :exercises

    create_table :exercises do |t|
      t.integer  :lesson_plan_id,  null: false
      t.string   :exercise_dir,    null: true
      t.text     :content,         null: false
      t.string   :first_line,      null: false
      t.integer  :order_in_lesson, null: false
      t.timestamps
    end

    add_index :exercises, [:lesson_plan_id, :order_in_lesson]
  end

  def down
    drop_table :exercises

    create_table :exercises, id: false do |t|
      t.integer  :id,             null: false
      t.integer  :lesson_plan_id, null: false
      t.string   :first_line,     null: false
      t.text     :content
      t.timestamps
    end

    add_index :exercises, :id, unique: true
    add_index :exercises, :lesson_plan_id
  end
end
