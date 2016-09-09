class Cohorts < ActiveRecord::Migration
  def change
    rename_column :repos, :cohort_num, :cohort_id
    rename_column :students, :cohort_num, :cohort_id
  end
end
