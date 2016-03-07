class AddStudentEmail < ActiveRecord::Migration
  def change
    add_column :students, :email, :string
  end
end
