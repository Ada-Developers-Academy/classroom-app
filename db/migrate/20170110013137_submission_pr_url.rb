class SubmissionPrUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :pr_url, :string
  end
end
