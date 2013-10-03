class CreateRefreshes < ActiveRecord::Migration
  def change
    create_table :refreshes do |t|
      t.integer :user_id,     null: false
      t.integer :repo_id,     null: false
      t.integer :exercise_id, null: false
      t.timestamp :logged_at, null: false
    end

    add_index :refreshes, :user_id
    add_index :refreshes, :repo_id
    add_index :refreshes, :exercise_id
  end
end
