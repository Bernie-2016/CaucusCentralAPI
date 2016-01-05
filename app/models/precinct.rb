class Precinct < ActiveRecord::Base
  validates :name, :county, presence: true

  has_and_belongs_to_many :users
end
