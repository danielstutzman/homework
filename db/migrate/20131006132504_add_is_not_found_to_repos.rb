class AddIsNotFoundToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :is_not_found, :boolean, null: false, default: false
  end
end
