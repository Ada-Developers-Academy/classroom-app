class AddFeedbackUrl < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :feedback_url, :string
  end
end
