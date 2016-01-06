Fabricator(:precinct) do
  name 'Des Moines 1'
  county 'Polk'
  total_attendees 100
  total_delegates 5
  delegate_counts { { sanders: 50, clinton: 40, omalley: 10 } }
end
