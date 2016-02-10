class Precinct < ActiveRecord::Base
  belongs_to :state
  has_many :reports
  has_many :users

  has_one :captain, class_name: 'User'

  default_scope -> { order(county: :asc, name: :asc) }

  validates :name, :county, presence: true
end
