class AddFeedbackProvider < ActiveRecord::Migration[5.2]
  def change
    add_reference :submissions, :user, index: true
    add_foreign_key :submissions, :users
  end
end
