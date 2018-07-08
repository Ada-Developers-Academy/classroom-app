class AddStudentEmail < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :email, :string
  end
end
