class CreateRefreshes < ActiveRecord::Migration
  def change
    create_table :refreshes do |t|
      t.integer   :user_id,      null: false
      t.integer   :repo_id,      null: false
      t.string    :exercise_dir, null: true
      t.string    :exercise_id,  null: true
      t.timestamp :logged_at,    null: false
    end

    add_index :refreshes, :user_id
    add_index :refreshes, :repo_id
    add_index :refreshes, :exercise_dir
    add_index :refreshes, :exercise_id
  end
end
