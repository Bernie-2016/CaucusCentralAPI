class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :code
      t.date :caucus_date
      
      t.timestamps null: false
    end
  end
end
