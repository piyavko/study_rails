class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can :create, Article
      can :update, Article do |article|
        article.try(:user) == user
      end
      can :destroy, Article do |article|
        article.try(:user) == user
      end
      can :create, Comment
      can :update, Comment do |comment|
        comment.try(:user) == user
      end
      can :destroy, Comment do |comment|
        (comment.try(:user) == user) || (comment.article.user == user)
      end
    end
  end
end
