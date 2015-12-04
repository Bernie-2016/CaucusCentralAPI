class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string, null: false
  end
end
