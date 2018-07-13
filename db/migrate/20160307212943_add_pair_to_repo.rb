class AddPairToRepo < ActiveRecord::Migration[5.2]
  def change
    add_column :repos, :individual, :boolean, :default => true 
  end
end
