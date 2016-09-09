class RemoveOneToOneRepoCohort < ActiveRecord::Migration
  def change
    remove_column :repos, :cohort_id
  end
end
