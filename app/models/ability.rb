class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    if user.admin? || user.super_admin?
      can :manage, User
      can :manage, Segment
      can :manage_user_batch_action, User
      can :unlock, User do |unlockable_user|
        user != unlockable_user
      end
      can :lock, User do |lockable_user|
        user != lockable_user
      end
      can :manage_profile, User
    elsif user.representative?
      can :manage, Segment do |segment|
        represented_segments_trees_ids(user).include? segment.id
      end

      can :manage, User do |authorizable_user|
        within_representative_tree?(authorizable_user)
      end

      can :unlock, User do |unlockable_user|
        within_representative_tree?(unlockable_user) && user != unlockable_user
      end

      can :lock, User do |lockable_user|
        within_representative_tree?(lockable_user) && user != lockable_user
      end

      can :manage_profile, User do |profileable_user|
        within_representative_tree?(lockable_user)
      end
    else
      can :manage_profile, User do |user_profile|
        user_profile == user
      end
    end

    def within_representative_tree?(authorizable_user)
      !User.unscoped.joins(:user_segments)
        .where(user_segments: { segment_id: represented_segments_trees_ids(user), user_id: authorizable_user.id }).empty?
    end

    def represented_segments_trees_ids(user)
      user.represented_segments.map do |represented_segment|
        represented_segment.self_and_descendant_ids
      end.flatten
    end
  end
end
