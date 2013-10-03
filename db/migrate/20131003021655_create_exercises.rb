class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :dir_name, null: false

      t.timestamps
    end

    add_index :exercises, :dir_name
  end
end
