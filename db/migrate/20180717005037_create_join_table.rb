class CreateJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :students_submissions do |t|
      t.integer :submission_id, null: false
      t.string :student_id, null: false
      t.index [:submission_id, :student_id], :unique => true, :name => "index_submission_id_and_student_id"

      t.timestamps null: false
    end
  end
end
