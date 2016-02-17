class AddStateToInvitations < ActiveRecord::Migration
  def change
    add_reference :invitations, :state, index: true
  end
end
