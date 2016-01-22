module Api
  module V1
    class ReportsController < ApplicationController
      skip_before_action :authenticate!, only: [:create]

      def create
        report = current_precinct.reports.new(report_params)
        authorize! :create, report
        if report.save
          render json: ReportSerializer.root_hash(report), status: :created
        else
          render json: report.errors.inspect, status: :unprocessable_entity
        end
      end

      def update
        authorize! :admin, current_report

        if current_report.update(report_params)
          render json: ReportSerializer.root_hash(report), status: :ok, location: api_v1_report_url(current_report)
        else
          render json: { error: current_report.errors.inspect }, status: :unprocessable_entity
        end
      end

      private

      def current_precinct
        @current_precinct ||= Precinct.find(params[:precinct_id])
      end

      def current_report
        @current_report ||= current_precinct.reports.find_by(id: params[:id])
      end

      def report_params
        rp = params.require(:report).permit(:total_attendees, :phase, delegate_counts: [:key, :supporters])

        phase = rp.delete(:phase)
        rp[:aasm_state] = phase if phase && Report.aasm.states.map(&:name).include?(phase.intern)

        # Update delegate counts
        delegate_counts = current_report.try(:delegate_counts) || {}
        (rp.delete(:delegate_counts) || []).each do |delegate|
          next unless Candidate.keys.include? delegate['key']
          delegate_counts[delegate['key'].intern] = delegate['supporters'].to_i
        end
        rp[:delegate_counts] = delegate_counts

        rp[:source] =
          if logged_in?
            current_user.organizer? ? :manual : :captain
          else
            :crowd
          end

        rp
      end
    end
  end
end
