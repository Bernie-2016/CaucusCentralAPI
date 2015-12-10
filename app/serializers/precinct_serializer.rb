class PrecinctSerializer < ActiveModel::Serializer
  attributes :id, :name, :county, :supporting_attendees, :total_attendees
end
