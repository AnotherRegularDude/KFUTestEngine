class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, length: { in: 5..15 }, uniqueness: true
  validates :first_name, :second_name, :patronymic, presence: true, length: { min: 4 }

  after_initialize :set_default_values

  def username=(value)
    self[:username] = value.downcase
  end

  private

  def set_default_values
    self.is_teacher ||= false
  end
end
