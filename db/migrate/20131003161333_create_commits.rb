class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer   :user_id,           null: false
      t.integer   :repo_id,           null: false
      t.string    :sha,               null: false
      t.string    :message,           null: false
      t.string    :exercise_dirs_csv, null: false
      t.timestamp :committed_at,      null: false

      t.timestamps
    end

    add_index :commits, :sha, unique: true
    add_index :commits, :committed_at
  end
end
