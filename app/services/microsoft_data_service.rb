class MicrosoftDataService
  class << self
    def perform!
      response = RestClient.get 'https://www.idpcaucuses.com/api/PrecinctCandidateResults', accept: :json
      data = JSON.parse(response)
      data['PrecinctResults'].each do |result|
        precinct = Precinct.find_by(name: "#{result['County']['Name']}-#{result['Precinct']['Name']}")
        unless precinct
          num = /\d+/.match(result['Precinct']['Name']).try(:[], 0)
          precinct = Precinct.where(county: result['County']['Name'].upcase).where('name like ?', "%#{num}%").first
        end
        unless precinct
          num = /\d+/.match(result['Precinct']['Name']).try(:[], 0)
          name = PrecinctMapService.locate(result['County']['Name'].upcase, num)
          precinct = Precinct.find_by(name: name) if name
        end
        next unless precinct

        report = precinct.reports.microsoft.first || precinct.reports.microsoft.new(aasm_state: :completed)
        report.results_counts ||= {}
        result['Candidates'].each do |candidate|
          next unless %w(Clinton O'Malley Sanders Uncommitted).include? candidate['Candidate']['LastName']
          report.results_counts[candidate['Candidate']['LastName'].delete('\'').downcase.intern] = candidate['Result'] if candidate['Result']
        end
        report.save unless report.results_counts == {}
      end
    end
  end
end
