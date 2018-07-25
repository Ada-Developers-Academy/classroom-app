class RenameRepoToAssignmet < ActiveRecord::Migration[5.2]
  def change
    remove_index :submissions, [:student_id, :repo_id]
    remove_index :cohorts_repos, [:cohort_id, :repo_id]

    rename_table :repos, :assignments
    rename_table :cohorts_repos, :cohorts_assignments

    rename_column :cohorts_assignments, :repo_id, :assignment_id
    rename_column :submissions, :repo_id, :assignment_id

    # add_index :submissions, [:student_id, :assignment_id], unique: true
    add_index :cohorts_assignments, [:cohort_id, :assignment_id], unique: true
  end
end
