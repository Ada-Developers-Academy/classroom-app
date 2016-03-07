class AddPairToRepo < ActiveRecord::Migration
  def change
    add_column :repos, :individual, :boolean, :default => true 
  end
end
