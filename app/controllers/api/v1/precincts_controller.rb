module Api
  module V1
    class PrecinctsController < ApplicationController
      skip_authorization_check only: [:index]
      skip_before_action :authenticate!, only: [:index]

      def index
        render json: PrecinctSerializer.root_collection_hash(State.current.precincts.all, basic: true)
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
        report = current_precinct.reports.captain.create(user: current_user, total_attendees: params[:precinct][:total_attendees])
        report.begin!
        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def viability
        authorize! :update, current_precinct

        report = current_precinct.reports.captain.viability.where(user: current_user).first.dup

        # Update delegate counts
        report.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          report.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        report.save
        report.viable!

        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def apportionment
        authorize! :update, current_precinct

        report = current_precinct.reports.captain.apportionment.where(user: current_user).first.dup

        # Update delegate counts
        report.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          report.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        report.save

        if report.needs_flip?
          report.apportion_preflip!
        else
          report.apportion!
        end

        render json: PrecinctSerializer.root_hash(current_precinct), status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      end

      def flip
        authorize! :update, current_precinct

        report = current_precinct.reports.captain.coin_flip.where(user: current_user).first

        winner = params[:precinct][:flip_winner]
        report.update(flip_winner: winner) if Candidate.keys.include?(winner)
        report.flip!

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
