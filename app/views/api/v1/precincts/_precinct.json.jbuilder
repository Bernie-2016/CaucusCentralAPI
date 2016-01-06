json.id precinct.id
json.name precinct.name
json.county precinct.county
json.total_delegates precinct.total_delegates
json.phase precinct.aasm_state

unless precinct.start?
  json.total_attendees precinct.total_attendees

  unless precinct.viability?
    json.is_viable precinct.aasm_state != 'not_viable'
    json.delegate_counts do
      json.array! Candidate.keys do |key|
        json.key key
        json.name Candidate.name(key)
        json.supporters precinct.candidate_count(key)

        unless precinct.apportionment?
          json.delegates_won precinct.candidate_delegates(key)
        end
      end
    end
  end
end
