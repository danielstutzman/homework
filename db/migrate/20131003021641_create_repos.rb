class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :user_id, null: false
      t.string :url, null: false

      t.timestamps
    end

    add_index :repos, :user_id
    add_index :repos, :url, unique: true
  end
end
