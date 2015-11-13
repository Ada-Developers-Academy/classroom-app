class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name, null:false
      t.integer :cohort_num, null:false
      t.string :github_name, null:false
      
      t.timestamps null: false
    end
  end
end
