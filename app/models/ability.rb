class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.organizer?

    can :manage, Precinct do |precinct|
      if user.organizer?
        true
      elsif user.unassigned?
        false
      else
        user.precincts.include?(precinct)
      end
    end

    can :create, Token
    can :destroy, Token do |token|
      user == token.user
    end
  end
end
