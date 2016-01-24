class RemoveOutdatedPrecinctFields < ActiveRecord::Migration
  def change
    remove_column :precincts, :total_attendees, :integer, default: 0
    remove_column :precincts, :delegate_counts, :integer, default: 0
    remove_column :precincts, :aasm_state, :string
  end
end
