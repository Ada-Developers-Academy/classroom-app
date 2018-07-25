class RemoveJoinTableForAssignmentClassrooms < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :assignments, :classrooms
    add_reference :assignments, :classroom, index: true
    remove_column :submissions, :student_id
  end
end
