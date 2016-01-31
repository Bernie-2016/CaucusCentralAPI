class AddFlipWinnerToReports < ActiveRecord::Migration
  def change
    add_column :reports, :flip_winner, :string
  end
end
