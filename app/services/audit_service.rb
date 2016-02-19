class AuditService
  class << self
    def perform!
      State.find_by(code: 'NV').precincts.each do |precinct|
        # Find captain report, skip if not in yet.
        captain_report = precinct.reports.captain.completed.first || precinct.reports.manual.completed.first
        next unless captain_report

        # Check for possible delegate miscalculations.
        if captain_report.calculated_delegates[:sanders] != captain_report.results_counts[:sanders] && precinct.audits.miscalculation.none?
          audit = precinct.audits.miscalculation.new
          audit.supporter_counts = captain_report.delegate_counts
          audit.reported_results = captain_report.results_counts
          audit.save
        end

        # Check for delegate mismatches.
        official_report = precinct.reports.microsoft.first
        next unless official_report
        next unless captain_report.results_counts[:sanders] != official_report.results_counts[:sanders] && precinct.audits.delegate_mismatch.none?
        audit = precinct.audits.delegate_mismatch.new
        audit.supporter_counts = captain_report.delegate_counts
        audit.reported_results = captain_report.results_counts
        audit.official_results = official_report.results_counts
        audit.save
      end
    end
  end
end
