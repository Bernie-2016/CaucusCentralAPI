class StateSerializer < JsonSerializer
  class << self
    def hash(state, options = {})
      node = hash_for(state, %w(name code caucus_date))
      node[:precincts] = PrecinctSerializer.collection_hash(state.precincts.includes(:captain, :reports), basic_reports: options[:basic_reports]) unless options[:skip_precincts]
      node
    end
  end
end
