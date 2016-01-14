module Api
  module V1
    class PrecinctsController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        render_unauthenticated! unless current_user.organizer?
        render :index, locals: { precincts: Precinct.all }
      end

      def show
        authorize! :read, current_precinct
        render :show, locals: { precinct: current_precinct }
      end

      def begin
        authorize! :update, current_precinct
        current_precinct.begin!
        current_precinct.update(total_attendees: params[:precinct][:total_attendees])
        render :show, locals: { precinct: current_precinct }, status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      rescue => e
        render json: { error: e.inspect }, status: :unprocessable_entity
      end

      def viability
        authorize! :update, current_precinct

        # Update delegate counts
        current_precinct.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          current_precinct.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        if current_precinct.above_threshold?
          current_precinct.viable!
        else
          current_precinct.not_viable!
        end

        render :show, locals: { precinct: current_precinct }, status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      rescue => e
        render json: { error: e.inspect }, status: :unprocessable_entity
      end

      def apportionment
        authorize! :update, current_precinct

        # Update delegate counts
        current_precinct.delegate_counts ||= {}
        (params[:precinct][:delegate_counts] || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          current_precinct.delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end

        current_precinct.apportion!

        render :show, locals: { precinct: current_precinct }, status: :ok, location: api_v1_precinct_url(current_precinct)
      rescue CanCan::AccessDenied
        raise
      rescue => e
        render json: { error: e.inspect }, status: :unprocessable_entity
      end

      private

      def current_precinct
        @current_precinct ||= Precinct.find(params[:id] || params[:precinct_id])
      end
    end
  end
end
