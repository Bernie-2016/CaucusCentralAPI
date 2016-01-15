module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate!, only: [:create, :reset_password]
      skip_authorization_check only: [:create, :reset_password]

      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = user.tokens.session.create
          render :create, locals: { user: user, token: token }
        else
          render_unauthenticated!
        end
      end

      def reset_password
        user = User.find_by(email: params[:email])
        user.send_reset! if user
        head :no_content
      end

      def destroy
        authorize! :destroy, current_token
        current_token.destroy
        head :no_content
      end
    end
  end
end
