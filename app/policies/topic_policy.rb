class TopicPolicy < ApplicationPolicy
  def show_additional_info?
    user&.teacher?
  end

  def create?
    user.teacher?
  end
end
