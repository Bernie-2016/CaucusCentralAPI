module Api
  module V1
    class StatesController < ApplicationController
      skip_authorization_check only: [:index, :csv]
      skip_before_action :authenticate!, only: [:csv]
      before_action :authenticate_csv!, only: [:csv]

      def index
        render_unauthenticated! unless current_user.organizer? || current_user.admin?
        states =
          if current_user.organizer?
            if current_user.state
              [current_user.state]
            else
              []
            end
          else
            State.all
          end
        render json: StateSerializer.root_collection_hash(states, skip_precincts: true)
      end

      def show
        authorize! :read, current_state
        render json: StateSerializer.root_hash(current_state, skip_reports: current_state.code == 'IA')
      end

      def csv
        send_data to_csv(Report.all.where.not(aasm_state: :start)), filename: "#{current_state.name.downcase}.csv"
      end

      private

      def current_state
        @current_state ||= State.includes(precincts: :reports).find_by(code: params[:id] || params[:state_id])
      end

      def authenticate_csv!
        token = Token.session.find_by(token: params[:token])
        render_unauthenticated! unless token && token.unexpired? && token.user.organizer?
      end

      def to_csv(reports)
        columns = %w(county precinct total_delegates source phase total_attendees sanders_supporters clinton_supporters omalley_supporters uncommitted_supporters sanders_delegates clinton_delegates omalley_delegates uncommitted_delegates)
        CSV.generate do |csv|
          csv << columns
          reports.each do |report|
            row = []
            row << report.precinct.county
            row << report.precinct.name
            row << report.precinct.total_delegates
            row << report.source
            row << report.aasm_state
            row << report.total_attendees
            row << report.candidate_count(:sanders)
            row << report.candidate_count(:clinton)
            row << report.candidate_count(:omalley)
            row << report.candidate_count(:uncommitted)
            row << report.final_candidate_delegates(:sanders)
            row << report.final_candidate_delegates(:clinton)
            row << report.final_candidate_delegates(:omalley)
            row << report.final_candidate_delegates(:uncommitted)

            csv << row
          end
        end
      end
    end
  end
end
