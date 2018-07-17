class AddOathTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :oauth_token, :text
  end
end
