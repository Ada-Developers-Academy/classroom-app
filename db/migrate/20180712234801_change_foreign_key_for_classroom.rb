class ChangeForeignKeyForClassroom < ActiveRecord::Migration[5.2]
  def change
      remove_index :assignments_cohorts, column: [:cohort_id, :assignment_id]
      remove_index :students, column: [:cohort_id, :github_name]
      remove_index :user_invites, column: [:cohort_id]

      remove_foreign_key :user_invites, :cohorts

      rename_table :cohorts, :classrooms
      rename_table :assignments_cohorts, :assignments_classrooms

      rename_column :assignments_classrooms, :cohort_id, :classroom_id
      rename_column :students, :cohort_id, :classroom_id
      rename_column :user_invites, :cohort_id, :classroom_id

      add_index :assignments_classrooms, [:classroom_id, :assignment_id], :unique => true
      add_index :students, [:classroom_id, :github_name], :unique => true
      add_index :user_invites, [:classroom_id]

      add_foreign_key :user_invites, :classrooms, column: :classroom_id, on_delete: :cascade
  end
end

