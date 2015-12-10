class Precinct < ActiveRecord::Base
  validates :name, presence: true
  validates :county, presence: true
end
