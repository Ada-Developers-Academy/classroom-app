class AddUidAndPrefNameToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :preferred_name, :string
    add_column :students, :uid, :string, unique: true # TODO: change to include cohort (allow for deferred students)
    add_index :students, [:uid], unique: true # TODO: change to include cohort (allow for deferred students)

    add_column :instructors, :uid, :string
    add_index :instructors, [:uid], unique: true

    add_column :user_invites, :uid, :string
    add_index :user_invites, [:classroom_id, :uid], unique: true
  end
end
