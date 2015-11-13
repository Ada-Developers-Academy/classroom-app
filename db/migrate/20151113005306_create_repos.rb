class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.integer :cohort_num, null:false
      t.string :repo_url, null:false
      
      t.timestamps null: false
    end
  end
end
