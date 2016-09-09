class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
      t.integer :number, null: false
      t.string :name, null: false
      
      t.timestamps null: false
    end
  end
end
