class AddStateToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :state, index: true
  end
end
