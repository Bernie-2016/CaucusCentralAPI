module Api
  module V1
    class InvitationsController < ApplicationController
      def create
        invitation = Invitation.new(invitation_params)
        authorize! :create, invitation
        invitation.sender = current_user

        if invitation.save
          render :create, locals: { invitation: invitation }, status: :created
        else
          render json: invitation.errors, status: :unprocessable_entity
        end
      end

      private

      def invitation_params
        # No need to check privilege because only organizers can invite users
        params.require(:invitation).permit(:email, :privilege)
      end
    end
  end
end
