class CreateUserInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :user_invites do |t|
      t.integer :inviter_id, null: false
      t.string :github_name, null: false
      t.string :role, default: 'unknown', null: false
      t.boolean :accepted, default: false, null: false

      t.timestamps null: false
    end

    add_foreign_key :user_invites, :users, column: :inviter_id, on_delete: :cascade
  end
end
