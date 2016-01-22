Fabricator(:report) do
  precinct { Fabricate(:precinct) }
  total_attendees 100
  delegate_counts { { sanders: 50, clinton: 40, omalley: 10 } }
  aasm_state :start
end

Fabricator(:viability_report, from: :report) do
  aasm_state :viability
end

Fabricator(:not_viable_report, from: :report) do
  aasm_state :not_viable
end

Fabricator(:apportionment_report, from: :report) do
  aasm_state :apportionment
end

Fabricator(:apportioned_report, from: :report) do
  aasm_state :apportioned
end
