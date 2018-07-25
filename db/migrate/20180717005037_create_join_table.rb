class CreateJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_table :students_submissions do |t|
      t.belongs_to :student, index: true
      t.belongs_to :submission, index: true
      
      t.timestamps null: false
    end
  end
end
