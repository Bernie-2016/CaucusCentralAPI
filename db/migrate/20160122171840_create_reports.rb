class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :precinct
      t.belongs_to :user
      t.integer :source
      t.string :aasm_state
      t.integer :total_attendees, default: 0
      t.text :delegate_counts

      t.timestamps null: false
    end
  end
end
