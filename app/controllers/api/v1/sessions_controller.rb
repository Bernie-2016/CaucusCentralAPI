module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate!, only: [:create]
      skip_authorization_check only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = user.tokens.create
          render :create, locals: { user: user, token: token }
        else
          render_unauthenticated!
        end
      end

      def destroy
        authorize! :destroy, current_token
        current_token.destroy
        head :no_content
      end
    end
  end
end
