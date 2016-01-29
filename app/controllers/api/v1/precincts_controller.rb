module Api
  module V1
    class PrecinctsController < ApplicationController
      skip_authorization_check only: [:index]
      skip_before_action :authenticate!, only: [:index]

      def index
        render json: PrecinctSerializer.root_collection_hash(Precinct.all, basic: true)
      end

      def show
        authorize! :read, current_precinct
        if current_user.organizer?
          render json: PrecinctSerializer.root_hash(current_precinct)
        else
          current_report
          render json: CaptainPrecinctSerializer.root_hash(current_precinct)
        end
      end

      def begin
        authorize! :update, current_precinct
        current_report.begin!
        current_report.update(total_attendees: params[:precinct][:total_attendees])
        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def viability
        authorize! :update, current_precinct

        # Update delegate counts
        current_report.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          current_report.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        if current_report.above_threshold?(:sanders)
          current_report.viable!
        else
          current_report.not_viable!
        end

        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def apportionment
        authorize! :update, current_precinct

        # Update delegate counts
        current_report.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          current_report.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        current_report.apportion!

        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def update
        authorize! :admin, current_precinct

        precinct_params = params.require(:precinct).permit(:county, :name, :total_delegates)

        if current_precinct.update(precinct_params)
          render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
        else
          render json: { error: current_precinct.errors.inspect }, status: :unprocessable_entity
        end
      rescue CanCan::AccessDenied
        raise
      rescue => e
        render json: { error: e.inspect }, status: :unprocessable_entity
      end

      private

      def current_precinct
        @current_precinct ||= Precinct.find(params[:id] || params[:precinct_id])
      end

      def current_report
        @current_report ||= Report.find_or_create_by(precinct: current_precinct, user: current_user)
        @current_report.captain! unless @current_report.captain?
        @current_report
      end
    end
  end
end
