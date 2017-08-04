class AddCohortToUserInvites < ActiveRecord::Migration
  def change
    add_reference :user_invites, :cohort, foreign_key: { on_delete: :cascade }
  end
end
