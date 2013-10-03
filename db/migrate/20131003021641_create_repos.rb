class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :user_id,   null: false
      t.string  :name,      null: false
      t.string  :https_url, null: false
      t.integer :hook_id,   null: true

      t.timestamps
    end

    add_index :repos, :user_id
    add_index :repos, :https_url, unique: true
  end
end
