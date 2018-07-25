class AddNameToAssignment < ActiveRecord::Migration[5.2]
  def change
    add_column :assignments, :name, :string
  end
end
