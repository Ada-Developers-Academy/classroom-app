class AddCohortsReposTable < ActiveRecord::Migration
  def change
    create_table :cohorts_repos do |t|
      t.integer :cohort_id, null: false
      t.string :repo_id, null: false

      t.timestamps null: false
    end
  end
end
