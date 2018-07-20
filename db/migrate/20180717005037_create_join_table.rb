class CreateJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :students_submission_groups do |t|
      t.integer :submission_group_id, null: false
      t.string :student_id, null: false
      t.index [:submission_group_id, :student_id], :unique => true, :name => "index_group_id_and_student_id"

      t.timestamps null: false
    end
  end
  # def change
  #   create_join_table :submission_groups, :students do |t|
  #     t.index [:submission_group_id, :student_id], :unique => true, :name => "index_group_id_and_student_id"
  #     # t.index [:student_id, :submission_group_id], :unique => true, :name => "index_student_id_and_group_id"
  #   end
  # end
end
