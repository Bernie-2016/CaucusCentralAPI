module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate!, only: [:create]
      skip_authorization_check only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          user.tokens.create
        else
          render_unauthenticated!
        end
        render json: user, serializer: UserSerializer
      end

      def destroy
        authorize! :destroy, current_token
        current_token.destroy
        head :ok
      end
    end
  end
end
