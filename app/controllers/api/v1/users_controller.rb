module Api
  module V1
    class UsersController < ApplicationController
      skip_authorization_check only: [:index, :create]

      def index
        render_unauthenticated! unless current_user.organizer?
        render :index, locals: { users: User.all }
      end

      def show
        authorize! :read, current_param_user
        render :show, locals: { user: current_param_user }
      end

      def profile
        authorize! :read, current_user
        render :show, locals: { user: current_user }
      end

      def create
        user = User.new(user_params)
        authorize! :create, user

        if user.save
          render :show, locals: { user: user }, status: :created, location: api_v1_user_url(user)
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize! :update, current_param_user

        if current_param_user.update(user_params)
          render :show, locals: { user: current_param_user }, status: :ok, location: api_v1_user_url(current_param_user)
        else
          render json: current_param_user.errors, status: :unprocessable_entity
        end
      end

      def update_profile
        authorize! :update, current_user

        if current_user.update(user_params)
          render :show, locals: { user: current_user }, status: :ok, location: api_v1_user_url(current_user)
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :destroy, current_param_user
        current_param_user.destroy

        head :no_content
      end

      private

      def current_param_user
        @current_param_user ||= User.find(params[:id])
      end

      def user_params
        p = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :privilege, :invitation_token, :precinct_id)
        unless current_user.organizer?
          p.delete(:privilege)
          p.delete(:precinct_id)
        end
        p
      end
    end
  end
end
