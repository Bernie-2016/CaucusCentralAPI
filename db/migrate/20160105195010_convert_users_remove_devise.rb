class ConvertUsersRemoveDevise < ActiveRecord::Migration
  def up
    drop_table :users if ActiveRecord::Base.connection.table_exists? :users
 
    create_table(:users) do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.integer :privilege
    end
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
