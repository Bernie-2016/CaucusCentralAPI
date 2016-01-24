class Precinct < ActiveRecord::Base
  belongs_to :state
  has_many :reports
  has_many :users

  default_scope -> { order(name: :asc) }

  validates :name, :county, presence: true

  def captain
    User.where(precinct_id: id).first
  end

  def microsoft_report
    reports.microsoft.first
  end
end
