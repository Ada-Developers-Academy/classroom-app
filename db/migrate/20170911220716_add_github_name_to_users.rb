class AddGithubNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_name, :text
    add_index :users, :github_name, unique: true
  end
end
