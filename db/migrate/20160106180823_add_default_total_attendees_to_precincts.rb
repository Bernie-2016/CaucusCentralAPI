class AddDefaultTotalAttendeesToPrecincts < ActiveRecord::Migration
  def up
    change_column :precincts, :total_attendees, :integer, default: 0
  end

  def down
    change_column :precincts, :total_attendees, :integer, default: nil
  end
end
