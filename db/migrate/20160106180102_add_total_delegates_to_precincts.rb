class AddTotalDelegatesToPrecincts < ActiveRecord::Migration
  def change
    add_column :precincts, :total_delegates, :integer, default: 0
  end
end
