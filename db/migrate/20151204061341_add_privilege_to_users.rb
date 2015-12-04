class AddPrivilegeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privilege, :integer, default: 0, null: false
  end
end
