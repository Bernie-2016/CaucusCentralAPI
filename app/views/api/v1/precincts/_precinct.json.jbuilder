json.id precinct.id
json.name precinct.name
json.county precinct.county
json.total_attendees precinct.total_attendees
json.delegate_counts do
  json.array! Candidate.keys do |key|
    json.key key
    json.name Candidate.name(key)
    json.supporters precinct.candidate_count(key)
  end
end
