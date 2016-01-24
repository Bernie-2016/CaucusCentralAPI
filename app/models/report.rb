class Report < ActiveRecord::Base
  include AASM

  belongs_to :precinct
  belongs_to :user

  enum source: [:microsoft, :captain, :crowd, :manual]

  serialize :delegate_counts
  serialize :results_counts

  validates :precinct_id, :aasm_state, :total_attendees, presence: true

  aasm do
    state :start, initial: true
    state :viability
    state :not_viable
    state :apportionment
    state :apportioned

    event :begin do
      transitions from: :start, to: :viability
    end

    event :viable do
      transitions from: :viability, to: :apportionment
    end

    event :not_viable do
      transitions from: :viability, to: :not_viable
    end

    event :apportion do
      transitions from: :apportionment, to: :apportioned
    end
  end

  def candidate_count(key)
    (delegate_counts || {})[key.intern] || 0
  end

  def candidate_delegates(key)
    if (results_counts || {})[key]
      results_counts[key]
    else
      return 0 if total_attendees == 0
      (candidate_count(key).to_f * precinct.total_delegates.to_f / total_attendees.to_f).round.to_i
    end
  end

  def threshold
    multiplier =
      if precinct.total_delegates <= 2
        0.25
      elsif precinct.total_delegates == 3
        1.0 / 6.0
      else
        0.15
      end
    (total_attendees.to_f * multiplier).ceil
  end

  def above_threshold?
    delegate_counts[:sanders] >= threshold
  end

  def phase_pretty
    case aasm_state
    when 'start' then 'Ready to Begin'
    when 'viability' then 'Viability Phase'
    when 'not_viable' then 'Not Viable'
    when 'apportionment' then 'Apportionment Phase'
    when 'apportioned' then 'Caucus Completed'
    else 'Invalid precinct state'
    end
  end
end
