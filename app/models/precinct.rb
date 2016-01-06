class Precinct < ActiveRecord::Base
  validates :name, :county, presence: true

  has_many :users

  serialize :delegate_counts

  def candidate_count(key)
    (delegate_counts || {})[key.intern] || 0
  end
end
