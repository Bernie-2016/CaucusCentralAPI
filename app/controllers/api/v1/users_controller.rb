module Api
  module V1
    class UsersController < ApplicationController
      def index
      end

      def create
      end

      def update
      end

      def destroy
      end

      private

      def user_params
        p = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :privilege, precincts: [])
        p.delete(:privilege) unless current_user.organizer?
        p
      end
    end
  end
end
