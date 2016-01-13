json.name state.name
json.code state.code
json.caucus_date state.caucus_date.to_s
json.precincts do
  json.array! state.precincts, partial: 'api/v1/precincts/precinct', as: :precinct
end
