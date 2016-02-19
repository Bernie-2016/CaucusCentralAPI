class CreateAudits < ActiveRecord::Migration
  def change
    create_table :audits do |t|
      t.belongs_to :precinct
      t.integer :status, default: 0
      t.integer :audit_type
      t.text :supporter_counts
      t.text :reported_results
      t.text :official_results
      
      t.timestamps null: false
    end
  end
end
