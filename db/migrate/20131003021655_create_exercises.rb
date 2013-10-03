class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.integer :lesson_plan_id, null: false
      t.string  :dir,            null: false

      t.timestamps
    end

    add_index :exercises, :lesson_plan_id
    add_index :exercises, :dir
  end
end
