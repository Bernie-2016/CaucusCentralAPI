class LimitCandidateToOnePrecinct < ActiveRecord::Migration
  def up
    drop_table :precincts_users
    add_reference :users, :precinct, index: true
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
