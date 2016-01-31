Fabricator(:report) do
  precinct { Fabricate(:precinct) }
  total_attendees 100
  results_counts { {} }
  delegate_counts { { sanders: 50, clinton: 40, omalley: 10, uncommitted: 5 } }
  aasm_state :start
  source :captain
  flip_winner nil
end

Fabricator(:viability_report, from: :report) do
  aasm_state :viability
end

Fabricator(:apportionment_report, from: :report) do
  aasm_state :apportionment
end

Fabricator(:coin_flip_report, from: :report) do
  aasm_state :coin_flip
end

Fabricator(:apportioned_report, from: :report) do
  aasm_state :apportioned
end
