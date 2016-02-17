class EmailWorker
  include Sidekiq::Worker

  def perform
    columns = %w(county precinct total_delegates source phase total_attendees sanders_supporters clinton_supporters omalley_supporters uncommitted_supporters sanders_delegates clinton_delegates omalley_delegates uncommitted_delegates)
    csv_data = CSV.generate do |csv|
      csv << columns
      Report.all.where.not(aasm_state: :start).each do |report|
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

    ApplicationMailer.csv(csv_data).deliver_now
  end
end
