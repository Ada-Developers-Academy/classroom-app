class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.integer :student_id, null: false
      t.integer :repo_id, null: false
      t.datetime :submitted_at, null: false
      t.timestamps null: false
    end
  end
end
