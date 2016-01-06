class Precinct < ActiveRecord::Base
  validates :name, :county, presence: true

  has_many :users

  serialize :delegate_counts

  def candidate_count(key)
    (delegate_counts || {})[key.intern] || 0
  end

  def candidate_delegates(key)
    return 0 if total_attendees == 0
    (candidate_count(key).to_f * total_delegates.to_f / total_attendees.to_f).round.to_i
  end
end
