json.id precinct.id
json.name precinct.name
json.county precinct.county
json.total_attendees precinct.total_attendees
json.total_delegates precinct.total_delegates
json.phase precinct.aasm_state
json.is_viable precinct.aasm_state != 'not_viable'
json.delegate_counts do
  json.array! Candidate.keys do |key|
    json.key key
    json.name Candidate.name(key)
    json.supporters precinct.candidate_count(key)
    json.delegates_won precinct.candidate_delegates(key)
  end
end
