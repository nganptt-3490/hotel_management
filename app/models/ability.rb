class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    if user.admin?
      can :manage, :all
      cannot :create, Request
    elsif user.persisted?
      can :read, RoomType
      can :read, User
      cannot :read, :home
      can :create, Request
    else
      can :read, RoomType
      cannot :read, :home
    end
  end
end
