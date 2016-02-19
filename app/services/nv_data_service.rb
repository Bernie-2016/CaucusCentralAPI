class NvDataService
  class << self
    def perform!
      nv = State.find_by(code: 'NV')
      response = RestClient.get 'http://nvcaucuses.com/wp-content/themes/ndp/assets/map/data/data.json', accept: :json
      data = JSON.parse(response)
      data.each do |key, arr|
        # Skip if no data yet.
        next if arr[1..5].reduce(:+) == 0

        # Get name out of key.
        key = key.split('_')
        name = key.last

        # Fix/get county.
        if key.first == 'CARSON'
          county = 'CARSON CITY'
        elsif key.first == 'WHITE'
          county = 'WHITE PINE'
        else
          county = key.first
        end

        # Fix names with apostrophes.
        name = "Harrah's" if name == 'Harrahs'
        name = "Caesar's" if name == 'Caesars'

        # Lookup name.
        precinct = nv.precincts.where('upper(county) = ?', county).where(name: name).first

        report = precinct.reports.microsoft.first || precinct.reports.microsoft.new(aasm_state: :completed)
        report.results_counts ||= {}
        report.results_counts[:sanders] = arr[2]
        report.results_counts[:clinton] = arr[1]
        report.results_counts[:omalley] = arr[3]
        report.results_counts[:uncommitted] = arr[4]
        report.save
      end
    end
  end
end
