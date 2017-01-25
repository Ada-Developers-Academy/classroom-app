class SubmissionsFields < ActiveRecord::Migration
  def change
    change_column :submissions, :submitted_at, :datetime, null: true
  end
end
