class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can [:manage, :admin], :all if user.admin?

    can :read, State do |state|
      user.state == state if user.organizer?
    end

    can :manage, Precinct do |precinct|
      if user.organizer?
        user.state == precinct.state
      elsif user.captain?
        user.precinct == precinct
      end
    end
    can :admin, Precinct do |precinct|
      user.state == precinct.state if user.organizer?
    end

    can :create, Report
    can [:read, :admin], Report do |report|
      user.state == report.precinct.state if user.organizer?
    end

    can :update, Audit do |audit|
      user.state == audit.precinct.state if user.organizer?
    end

    can :create, Token
    can :destroy, Token do |token|
      user == token.user
    end

    can :manage, Invitation do |invitation|
      user.state == invitation.state && user.organizer?
    end

    can :manage, User do |u|
      user.state == u.state && user.organizer? || user == u
    end
  end
end
