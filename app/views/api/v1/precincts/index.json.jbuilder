json.precincts do
  json.array! precincts, partial: 'precinct', as: :precinct
end
