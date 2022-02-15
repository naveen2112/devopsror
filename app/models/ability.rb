# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    elsif user.editor?
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
