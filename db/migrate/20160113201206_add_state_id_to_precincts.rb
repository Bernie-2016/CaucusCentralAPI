class AddStateIdToPrecincts < ActiveRecord::Migration
  def change
    add_reference :precincts, :state, index: true
  end
end
