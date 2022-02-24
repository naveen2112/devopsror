# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.company.access_allowed?
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
    else
      if user.admin?
        can :read, Post
        can :manage, Company
      else
        can :read, Post
      end
    end
  end
end
