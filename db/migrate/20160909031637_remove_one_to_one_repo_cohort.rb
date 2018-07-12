class RemoveOneToOneRepoCohort < ActiveRecord::Migration[5.2]
  def change
    remove_column :repos, :cohort_id
  end
end
