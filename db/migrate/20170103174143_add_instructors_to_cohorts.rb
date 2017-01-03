class AddInstructorsToCohorts < ActiveRecord::Migration
  def change
    add_column :cohorts, :instructor_emails, :string
  end
end
