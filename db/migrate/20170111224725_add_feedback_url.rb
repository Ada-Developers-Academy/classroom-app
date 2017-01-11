class AddFeedbackUrl < ActiveRecord::Migration
  def change
    add_column :submissions, :feedback_url, :string
  end
end
