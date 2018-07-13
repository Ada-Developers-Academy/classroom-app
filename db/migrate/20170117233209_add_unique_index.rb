class AddUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :submissions, [:student_id, :repo_id], :unique => true
  end
end
