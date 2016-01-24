module Api
  module V1
    class UsersController < ApplicationController
      skip_authorization_check only: [:index, :create]
      skip_before_action :authenticate!, only: [:create, :reset_password]
      before_action :authenticate_create!, only: [:create]
      before_action :authenticate_reset_password!, only: [:reset_password]

      def index
        render_unauthenticated! unless current_user.organizer?
        render json: UserSerializer.root_collection_hash(User.all)
      end

      def show
        authorize! :read, current_param_user
        render json: UserSerializer.root_hash(current_param_user)
      end

      def profile
        authorize! :read, current_user
        render json: UserSerializer.root_hash(current_user)
      end

      def create
        user = User.new(user_params)

        if user.save
          render json: UserSerializer.root_hash(user), status: :created, location: api_v1_user_url(user)
        else
          render json: user.errors, status: :unprocessable_entity
        end
      end

      def import
        authorize! :create, User.new

        success_count = 0
        failed_users = []

        params[:users].each do |user|
          if User.exists?(email: user[:email]) || Invitation.exists?(email: user[:email])
            failed_users << { user: user, reason: 'User already exists' }
          else
            state = State.find_by(code: user[:code])
            if state
              precinct = state.precincts.find_by(county: user[:county], name: user[:precinct])
              if precinct
                Invitation.create(sender: current_user, email: user[:email], privilege: :captain, precinct: precinct)
                success_count += 1
              else
                failed_users << { user: user, reason: 'Precinct does not exist' }
              end
            else
              failed_users << { user: user, reason: 'State does not exist' }
            end
          end
        end

        render json: { importedCount: success_count, failedUsers: failed_users }, status: :created
      end

      def update
        authorize! :update, current_param_user

        if current_param_user.update(user_params)
          render json: UserSerializer.root_hash(current_param_user), status: :ok, location: api_v1_user_url(current_param_user)
        else
          render json: current_param_user.errors, status: :unprocessable_entity
        end
      end

      def update_profile
        authorize! :update, current_user

        if current_user.update(user_params)
          render json: UserSerializer.root_hash(current_user), status: :ok, location: api_v1_user_url(current_user)
        else
          render json: current_user.errors, status: :unprocessable_entity
        end
      end

      def reset_password
        authorize! :update, current_user

        if current_user.update(reset_params)
          render json: UserSerializer.root_hash(current_user), status: :ok, location: api_v1_user_url(current_user)
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
        p = params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :privilege, :invitation_token, :precinct_id)
        unless current_user && current_user.organizer?
          p.delete(:privilege)
          p.delete(:precinct_id)
        end
        p
      end

      def reset_params
        params.require(:user).permit(:password, :password_confirmation)
      end

      def authenticate_create!
        invitation = Invitation.find_by(token: request.headers['Authorization'])
        render_unauthenticated! unless invitation && invitation.unexpired?
      end

      def authenticate_reset_password!
        token = Token.reset.find_by(token: request.headers['Authorization'])
        render_unauthenticated! unless token && token.unexpired?
      end
    end
  end
end
