class MaterialPolicy < ApplicationPolicy
  def create?
    @user.teacher?
  end
end
