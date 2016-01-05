class CreatePrecinctsUsers < ActiveRecord::Migration
  def change
    create_table :precincts_users do |t|
      t.belongs_to :precinct
      t.belongs_to :user
    end
  end
end
