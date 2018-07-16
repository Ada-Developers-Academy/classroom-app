class CreateCohortsAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :cohorts do |t|
      t.integer :number
      t.string :name
      t.string :repo_name
      t.date :start_date
      t.date :end_date
      t.date :graduation_date

      t.timestamps null: false
    end
  end
end
