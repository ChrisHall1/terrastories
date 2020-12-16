class StoryPolicy < ApplicationPolicy
  attr_reader :user, :story

  def initialize(user, story)
    @user = user
    @story = story
  end

  def index?
    user.admin? || user.editor?
  end

  def new?
    user.admin? || user.editor?
  end

  def create?
    new?
  end

  def show?
    # anyone except super admins can view
    !user.super_admin
  end

  def edit?
    user.admin? || user.editor?
  end

  def update?
    edit?
  end

  def destroy?
    user.admin? || user.editor?
  end

  class Scope < Scope
    def resolve
      stories = user.community.stories.where(permission_level: :anonymous)
      if user&.member?
          stories = user.community.stories.where(permission_level: [:anonymous, :user_only])
      end
      if user&.editor? || user&.admin?
          stories = user.community.stories.all
      end
      stories.eager_load(:speakers, :places)
    end

    def resolve_admin
      scope.where(community: user.community)
    end
  end
end
