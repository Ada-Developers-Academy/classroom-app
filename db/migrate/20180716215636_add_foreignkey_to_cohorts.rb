class AddForeignkeyToCohorts < ActiveRecord::Migration[5.2]
  def change
    add_reference :classrooms, :cohort, foreign_key: { on_delete: :cascade }
  end
end
