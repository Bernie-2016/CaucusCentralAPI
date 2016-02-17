class ReportSerializer < JsonSerializer
  class << self
    def hash(report, _options = {})
      node = hash_for(report, %w(id created_at source precinct_id))
      node[:phase] = report.aasm_state

      unless report.start?
        node[:total_attendees] = report.total_attendees
        node[:threshold] = report.threshold

        unless report.viability?
          node[:delegate_counts] = Candidate.keys.map do |key|
            key_node = {}
            key_node[:key] = key
            key_node[:name] = Candidate.name(key)
            key_node[:supporters] = report.candidate_count(key)
            key_node[:viable] = report.viable?(key)
            key_node[:delegates_won] = report.candidate_delegates(key) if report.completed?
            key_node
          end
        end
      end

      node
    end
  end
end
