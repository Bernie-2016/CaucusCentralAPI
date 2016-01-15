class AddTokenTypeToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :token_type, :integer
  end
end
