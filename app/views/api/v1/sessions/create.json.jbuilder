json.user do
  json.id user.id
  json.first_name user.first_name
  json.last_name user.last_name
  json.email user.email
  json.privilege user.privilege
  json.precinct_id user.precinct_id
  json.token token.token
end
