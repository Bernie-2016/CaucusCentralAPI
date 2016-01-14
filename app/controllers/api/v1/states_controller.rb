module Api
  module V1
    class StatesController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        render_unauthenticated! unless current_user.organizer?
        render :index, locals: { states: State.all }
      end

      def show
        authorize! :read, current_state
        render :show, locals: { state: current_state }
      end

      private

      def current_state
        @current_state ||= State.find_by_code(params[:id])
      end
    end
  end
end
