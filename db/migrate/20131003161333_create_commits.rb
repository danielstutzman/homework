class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.integer   :user_id,      null: false
      t.integer   :repo_id,      null: false
      t.string    :sha,          null: false
      t.string    :message,      null: false
      t.string    :exercise_dir, null: true
      t.integer   :exercise_id,  null: true
      t.timestamp :committed_at, null: false

      t.timestamps
    end

    add_index :commits, :sha
    add_index :commits, :committed_at
  end
end
