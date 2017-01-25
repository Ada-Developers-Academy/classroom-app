class AddUniqueIndex < ActiveRecord::Migration
  def change
    add_index :submissions, [:student_id, :repo_id], :unique => true
  end
end
