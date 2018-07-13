class ChangeEnumToIntInSubmissionGrade < ActiveRecord::Migration[5.2]
  def up
    add_column :submissions, :grade, :integer
  end

  def down
    remove_column :submissions, :grade
  end
end
