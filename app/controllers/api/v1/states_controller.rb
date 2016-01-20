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

      def csv
        authorize! :read, current_state
        send_data to_csv(current_state.precincts), filename: "#{current_state.name.downcase}.csv"
      end

      private

      def current_state
        @current_state ||= State.find_by_code(params[:id] || params[:state_id])
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
