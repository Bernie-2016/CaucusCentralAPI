class AddPrivilegeToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :privilege, :integer
  end
end
