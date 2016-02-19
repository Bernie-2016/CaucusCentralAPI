class AuditSerializer < JsonSerializer
  class << self
    def hash(audit, _options = {})
      node = hash_for(audit, %w(id precinct_id status audit_type supporter_counts reported_results official_results))
      node[:precinct_name] = audit.precinct.try(:name)
      node[:precinct_state] = audit.precinct.try(:state).try(:code)
      node
    end
  end
end
