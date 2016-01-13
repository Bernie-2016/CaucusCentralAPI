class State < ActiveRecord::Base
  has_many :precincts

  default_scope -> { order(name: :asc) }

  validates :name, :code, :caucus_date, presence: true
  validates :name, :code, uniqueness: true
end
