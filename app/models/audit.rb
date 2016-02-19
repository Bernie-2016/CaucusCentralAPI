class Audit < ActiveRecord::Base
  belongs_to :precinct

  enum status: [:open, :closed]
  enum audit_type: [:miscalculation, :delegate_mismatch]

  serialize :supporter_counts
  serialize :reported_results
  serialize :official_results
end
