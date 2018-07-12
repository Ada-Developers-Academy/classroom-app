class SubmissionsFields < ActiveRecord::Migration[5.2]
  def change
    change_column :submissions, :submitted_at, :datetime, null: true
  end
end
