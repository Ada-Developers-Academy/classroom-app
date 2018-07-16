class AddInstructorsToCohorts < ActiveRecord::Migration[5.2]
  def change
    add_column :cohorts, :instructor_emails, :string
  end
end
