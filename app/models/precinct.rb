class Precinct < ActiveRecord::Base
  include AASM

  validates :name, :county, presence: true

  belongs_to :state

  has_many :users

  default_scope -> { order(name: :asc) }

  serialize :delegate_counts

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
    return 0 if total_attendees == 0
    (candidate_count(key).to_f * total_delegates.to_f / total_attendees.to_f).round.to_i
  end

  def threshold
    multiplier =
      if total_delegates <= 2
        0.25
      elsif total_delegates == 3
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
    when :start then 'Ready to Begin'
    when :viability then 'Viability Phase'
    when :not_viable then 'Not Viable'
    when :apportionment then 'Apportionment Phase'
    when :apportioned then 'Caucus Completed'
    else 'Invalid precinct state'
    end
  end
end
