class RenameCohortsAssignmentsToAssignmentsCohorts < ActiveRecord::Migration[5.2]
  def change
    rename_table :cohorts_assignments, :assignments_cohorts
  end
end
