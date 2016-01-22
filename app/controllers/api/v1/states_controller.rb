module Api
  module V1
    class StatesController < ApplicationController
      skip_authorization_check only: [:index, :csv]
      skip_before_action :authenticate!, only: [:csv]
      before_action :authenticate_csv!, only: [:csv]

      def index
        render_unauthenticated! unless current_user.organizer?
        render json: StateSerializer.root_collection_hash(State.all)
      end

      def show
        authorize! :read, current_state
        render json: StateSerializer.root_hash(current_state)
      end

      def csv
        send_data to_csv(current_state.precincts), filename: "#{current_state.name.downcase}.csv"
      end

      private

      def current_state
        @current_state ||= State.find_by_code(params[:id] || params[:state_id])
      end

      def authenticate_csv!
        token = Token.session.find_by(token: params[:token])
        render_unauthenticated! unless token && token.unexpired? && token.user.organizer?
      end

      def to_csv(precincts)
        columns = %w(county precinct phase total_attendees sanders clinton omalley total_delegates delegates_awarded)
        CSV.generate do |csv|
          csv << columns
          precincts.each do |precinct|
            row = []
            row << precinct.county
            row << precinct.name
            row << precinct.phase_pretty
            row << precinct.total_attendees
            row << precinct.candidate_count('sanders')
            row << precinct.candidate_count('clinton')
            row << precinct.candidate_count('omalley')
            row << precinct.total_delegates
            row << precinct.candidate_delegates('sanders')

            csv << row
          end
        end
      end
    end
  end
end
