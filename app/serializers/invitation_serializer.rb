class InvitationSerializer < JsonSerializer
  class << self
    def hash(invitation, _options = {})
      hash_for(invitation, %w(email privilege precinct_id))
    end
  end
end
