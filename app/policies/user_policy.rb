class UserPolicy < ApplicationPolicy
  def destroy?
    @user.teacher?
  end
end
