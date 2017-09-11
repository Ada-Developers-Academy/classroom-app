class UsePartialIndexOnUserInvites < ActiveRecord::Migration
  def change
    remove_index :user_invites, column: :github_name
    add_index :user_invites, :github_name, unique: true, where: 'accepted = false'
  end
end
