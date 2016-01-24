Fabricator(:precinct) do
  name 'Des Moines 1'
  county 'Polk'
  total_delegates 5
  state State.find_by_code('IA')
end
