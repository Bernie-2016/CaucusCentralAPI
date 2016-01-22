class PrecinctSerializer < JsonSerializer
  class << self
    def hash(precinct)
      node = hash_for(precinct, %w(id name county total_delegates))
      node[:state] = precinct.state.try(:code)
      node[:captain_id] = precinct.captain.try(:id)
      node[:captain_last_name] = precinct.captain.try(:last_name)
      node[:captain_first_name] = precinct.captain.try(:first_name)
      node[:reports] = ReportSerializer.collection_hash(precinct.reports)
      node
    end
  end
end
