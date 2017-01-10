class SubmissionPrUrl < ActiveRecord::Migration
  def change
    add_column :submissions, :pr_url, :string
  end
end
