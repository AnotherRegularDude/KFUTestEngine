class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, length: { in: 5..15 }, uniqueness: true
  validates :password, length: { minimum: 5 }
  validates :first_name, :second_name, :patronymic, presence: true, length: { minimum: 4 }

  after_initialize :set_default_values

  def username=(value)
    self[:username] = value.downcase
  end

  def fullname
    "#{second_name} #{first_name} #{patronymic}"
  end

  private

  def set_default_values
    self.is_teacher ||= false
  end
end
