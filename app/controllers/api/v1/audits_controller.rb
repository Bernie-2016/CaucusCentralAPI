module Api
  module V1
    class AuditsController < ApplicationController
      skip_authorization_check only: [:index]

      def index
        render_unauthenticated! unless current_user.organizer? || current_user.admin?
        audits = Audit.all.includes(:precinct)
        audits = audits.where(precinct_id: current_user.state.precincts.pluck(:id)) unless current_user.admin?
        render json: AuditSerializer.root_collection_hash(audits)
      end

      def update
        authorize! :update, current_audit

        if audit.update(audit_params)
          render json: AuditSerializer.root_hash(audit), status: :ok
        else
          render json: audit.errors, status: :unprocessable_entity
        end
      end

      private

      def current_audit
        @current_audit ||= Audit.find(params[:id])
      end

      def audit_params
        params.require(:audit).permit(:status)
      end
    end
  end
end
