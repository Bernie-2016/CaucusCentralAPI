class IndexReportsOnPrecinctAndState < ActiveRecord::Migration
  def change
  	add_index :reports, :precinct_id
  	add_index :reports, :aasm_state
  end
end
