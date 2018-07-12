class ChangeEnumToIntInSubmissionGrade < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :grade, :integer
  end
end
