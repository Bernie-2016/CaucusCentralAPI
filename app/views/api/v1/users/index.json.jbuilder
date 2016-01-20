json.cache! users do
  json.users do
    json.cache_collection! users do |user|
      json.id user.id
      json.first_name user.first_name
      json.last_name user.last_name
      json.email user.email
      json.phone_number user.phone_number
      json.precinct_id user.precinct_id
      json.precinct_name user.precinct.try(:name)
      json.precinct_state user.precinct.try(:state).try(:code)
      json.privilege user.privilege
    end
  end
end
