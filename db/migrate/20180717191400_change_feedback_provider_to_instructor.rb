class ChangeFeedbackProviderToInstructor < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :submissions, :users
    remove_reference :submissions, :user

    add_reference :submissions, :instructor, index: true
    add_foreign_key :submissions, :instructors
  end
end
