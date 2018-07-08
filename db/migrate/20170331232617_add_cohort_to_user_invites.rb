class AddCohortToUserInvites < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_invites, :cohort, foreign_key: { on_delete: :cascade }
  end
end
