# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "admin"
      can :manage, User
      can :manage, Post
      can :manage, Company
      can :manage, IntegratedAccount
      can :manage, Commentry
      can :manage, Card
      can :manage, Tag
    elsif user.role == "editor"
      can :manage, Post
      can :manage, IntegratedAccount
      can :manage, Commentry
      can :manage, Tag
    else
      can :manage, IntegratedAccount
      can :read, Post
    end
  end
end
