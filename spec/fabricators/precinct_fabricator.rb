Fabricator(:precinct) do
  name                 "Des Moines 1"
  county               "Polk"
  supporting_attendees 99
  total_attendees      100
end

Fabricator(:invalid_precinct, from: :precinct) do
  name                 ""
  county               ""
end
