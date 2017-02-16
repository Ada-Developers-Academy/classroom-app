class AddFeedbackProvider < ActiveRecord::Migration
  def change
    add_reference :submissions, :user, index: true
    add_foreign_key :submissions, :users
  end
end
