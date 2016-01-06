class AddPrecinctIdToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :precinct_id, :integer
  end
end
