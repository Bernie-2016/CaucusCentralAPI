class AddResultCountsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :results_counts, :text
  end
end
