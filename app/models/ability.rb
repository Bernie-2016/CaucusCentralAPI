class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.organizer?

    can :manage, Precinct do |precinct|
      if user.organizer?
        true
      elsif user.captain?
        user.precinct == precinct
      end
    end
    can :admin, Precinct if user.organizer?

    can :create, Report
    can [:read, :admin], Report if user.organizer?

    can :create, Token
    can :destroy, Token do |token|
      user == token.user
    end

    can :manage, User do |u|
      user == u
    end
  end
end
