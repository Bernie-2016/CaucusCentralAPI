class CaptainPrecinctSerializer < JsonSerializer
  class << self
    def root_hash(precinct, options = {})
      node = PrecinctSerializer.hash(precinct)
      node[:reports] = [ReportSerializer.hash(precinct.reports.captain.find_by(user: options[:user] || precinct.captain))]
      { precinct: node }
    end
  end
end
