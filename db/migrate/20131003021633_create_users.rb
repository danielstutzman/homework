class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :github_username, null: false

      t.timestamps
    end

    add_index :users, :github_username, unique: true
  end
end
