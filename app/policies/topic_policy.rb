class TopicPolicy < ApplicationPolicy
  def create?
    user.teacher?
  end
end
