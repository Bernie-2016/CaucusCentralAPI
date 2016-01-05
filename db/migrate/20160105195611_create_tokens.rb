class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.belongs_to :user
      t.string :token

      t.timestamps null: false
    end
  end
end
