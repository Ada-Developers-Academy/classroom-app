class AddUidAndPrefNameToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :preferred_name, :string
    add_column :students, :uid, :string

    # add_foreign_key :submissions, :std
  end
end
