class CreateInstructors < ActiveRecord::Migration[5.2]
  def change
    create_table :instructors do |t|
      t.string :name, null: false
      t.string :github_name, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
