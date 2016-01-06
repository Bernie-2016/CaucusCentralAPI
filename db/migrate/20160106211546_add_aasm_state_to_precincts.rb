class AddAasmStateToPrecincts < ActiveRecord::Migration
  def change
    add_column :precincts, :aasm_state, :string
  end
end
