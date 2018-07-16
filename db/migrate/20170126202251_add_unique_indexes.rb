class AddUniqueIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :users, [:uid, :provider], unique: true

    add_index :students, [:cohort_id, :github_name], unique: true
    add_index :user_invites, :github_name, unique: true

    add_index :cohorts_repos, [:cohort_id, :repo_id], unique: true
    add_index :cohorts, [:number, :name], unique: true
  end
end
