class InvitationSerializer < JsonSerializer
  class << self
    def hash(invitation, _options = {})
      node = hash_for(invitation, %w(id email privilege precinct_id token))
      node[:precinct_name] = invitation.precinct.try(:name)
      node[:precinct_state] = invitation.precinct.try(:state).try(:code)
      node
    end
  end
end
