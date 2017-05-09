class TopicPolicy < ApplicationPolicy
  def show_additional_info?
    user&.teacher?
  end

  def create?
    user.teacher?
  end

  def update?
    user.teacher?
  end

  def destroy?
    user.teacher?
  end
end
