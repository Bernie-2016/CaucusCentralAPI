class InvitationSerializer < JsonSerializer
  class << self
    def hash(invitation)
      hash_for(invitation, %w(email privilege precinct_id))
    end
  end
end
