class CreatePrecincts < ActiveRecord::Migration
  def change
    create_table :precincts do |t|
      t.string :name
      t.string :county
      t.integer :supporting_attendees
      t.integer :total_attendees

      t.timestamps null: false
    end
  end
end
