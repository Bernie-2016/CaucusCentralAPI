class AddDelegateCountsToPrecincts < ActiveRecord::Migration
  def change
    add_column :precincts, :delegate_counts, :text
    remove_column :precincts, :supporting_attendees, :integer
  end
end
