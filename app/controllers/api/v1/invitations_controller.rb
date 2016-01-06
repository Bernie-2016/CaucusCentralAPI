module Api
  module V1
    class InvitationsController < ApplicationController
      def create
        invitation = Invitation.new(email: params[:email])
        authorize! :create, invitation
        invitation.sender = current_user

        if invitation.save
          render :create, locals: { invitation: invitation }, status: :created
        else
          render json: invitation.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
