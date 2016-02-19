module Api
  module V1
    class AuditsController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        render_unauthenticated! unless current_user.organizer? || current_user.admin?
        audits = Audit.open.includes(:precinct)
        audits = audits.where(precinct_id: current_user.state.precincts.pluck(:id)) unless current_user.admin?
        render json: AuditSerializer.root_collection_hash(audits)
      end

      def update
        authorize! :update, current_audit

        if current_audit.update(audit_params)
          render json: AuditSerializer.root_hash(current_audit), status: :ok
        else
          render json: current_audit.errors, status: :unprocessable_entity
        end
      end

      def csv
        audits = Audit.all.includes(:precinct)
        audits = audits.where(precinct_id: current_user.state.precincts.pluck(:id)) unless current_user.admin?
        send_data to_csv(audits), filename: 'audits.csv'
      end

      private

      def current_audit
        @current_audit ||= Audit.find(params[:id])
      end

      def audit_params
        params.require(:audit).permit(:status)
      end

      def to_csv(audits)
        columns = %w(county precinct total_delegates status type sanders_supporters clinton_supporters omalley_supporters uncommitted_supporters sanders_reported_delegates clinton_reported_delegates omalley_reported_delegates uncommitted_reported_delegates sanders_official_delegates clinton_official_delegates omalley_official_delegates uncommitted_official_delegates)
        CSV.generate do |csv|
          csv << columns
          audits.each do |audit|
            row = []
            row << audit.precinct.county
            row << audit.precinct.name
            row << audit.precinct.total_delegates
            row << audit.status
            row << audit.audit_type
            row << audit.supporter_counts[:sanders]
            row << audit.supporter_counts[:clinton]
            row << audit.supporter_counts[:omalley]
            row << audit.supporter_counts[:uncommitted]
            row << audit.reported_results[:sanders]
            row << audit.reported_results[:clinton]
            row << audit.reported_results[:omalley]
            row << audit.reported_results[:uncommitted]

            if audit.delegate_mismatch?
              row << audit.official_results[:sanders]
              row << audit.official_results[:clinton]
              row << audit.official_results[:omalley]
              row << audit.official_results[:uncommitted]
            end

            csv << row
          end
        end
      end
    end
  end
end
