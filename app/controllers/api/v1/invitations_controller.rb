module Api
  module V1
    class InvitationsController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        accepted_ids = User.pluck(:invitation_id).compact
        render_unauthenticated! unless current_user.organizer? || current_user.admin?
        invitations = Invitation.where.not(id: accepted_ids)
        invitations = invitations.where(precinct_id: current_user.state.precincts.pluck(:id)) unless current_user.admin?
        render json: InvitationSerializer.root_collection_hash(invitations)
      end

      def create
        invitation = Invitation.new(invitation_params)
        authorize! :create, invitation
        invitation.sender = current_user
        invitation.state = current_user.state

        if invitation.save
          render json: InvitationSerializer.root_hash(invitation), status: :created
        else
          render json: invitation.errors, status: :unprocessable_entity
        end
      end

      def resend
        invitation = Invitation.find(params[:invitation_id])
        authorize! :manage, invitation
        if invitation.user.nil?
          invitation.send_invite
          head :ok
        else
          render json: { errors: 'Invitation has already been redeemed' }, status: :unprocessable_entity
        end
      end

      private

      def invitation_params
        # No need to check privilege because only organizers can invite users
        params.require(:invitation).permit(:email, :privilege, :precinct_id)
      end
    end
  end
end
