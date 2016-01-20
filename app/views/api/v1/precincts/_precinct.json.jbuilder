json.id precinct.id
json.name precinct.name
json.county precinct.county
json.state precinct.state.try(:code)
json.total_delegates precinct.total_delegates
json.phase precinct.aasm_state
json.captain_id precinct.captain.try(:id)
json.captain_last_name precinct.captain.try(:last_name)
json.captain_first_name precinct.captain.try(:first_name)

unless precinct.start?
  json.total_attendees precinct.total_attendees
  json.threshold precinct.threshold

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
