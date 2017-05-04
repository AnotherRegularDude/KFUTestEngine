class UserPolicy < ApplicationPolicy
  def permitted_attributes
    %i[first_name last_name patronymic]
  end

  def update?
    user.id == record.id || user.teacher?
  end

  def destroy?
    user.teacher?
  end
end
