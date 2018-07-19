class AddUidAndPrefNameToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :preferred_name, :string
    add_column :students, :uid, :string

    add_column :instructors, :uid, :string
    add_column :user_invites, :uid, :string
  end
end
