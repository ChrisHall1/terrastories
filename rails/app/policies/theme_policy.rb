class ThemePolicy < ApplicationPolicy
  attr_accessor :user, :theme

  def initialize(user, theme)
    @user = user
    @theme = theme
  end

  def index?
    user.admin?
  end

  def new?
    false
  end

  def show?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
