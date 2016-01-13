Fabricator(:precinct) do
  name 'Des Moines 1'
  county 'Polk'
  total_attendees 100
  total_delegates 5
  delegate_counts { { sanders: 50, clinton: 40, omalley: 10 } }
  state State.find_by_code('IA')
end

Fabricator(:viability_precinct, from: :precinct) do
  aasm_state :viability
end

Fabricator(:not_viable_precinct, from: :precinct) do
  aasm_state :not_viable
end

Fabricator(:apportionment_precinct, from: :precinct) do
  aasm_state :apportionment
end

Fabricator(:apportioned_precinct, from: :precinct) do
  aasm_state :apportioned
end
