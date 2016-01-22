class StateSerializer < JsonSerializer
  class << self
    def hash(state)
      node = hash_for(state, %w(name code caucus_date))
      node[:precincts] = PrecinctSerializer.collection_hash(state.precincts)
      node
    end
  end
end
