module Api
  module V1
    class InvitationsController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        render_unauthenticated! unless current_user.organizer?
        render json: InvitationSerializer.root_collection_hash(Invitation.all)
      end

      def create
        invitation = Invitation.new(invitation_params)
        authorize! :create, invitation
        invitation.sender = current_user

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
