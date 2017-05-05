class User < ApplicationRecord
  has_secure_password

  validates :username, presence: true, length: { in: 5..15 }, uniqueness: true
  validates :password, length: { minimum: 5 }, on: :create
  validates :first_name, :last_name, :patronymic, presence: true, length: { minimum: 4 }

  after_initialize :set_default_values
  before_validation :fields_format

  def fullname
    "#{last_name} #{first_name} #{patronymic}"
  end

  def teacher?
    is_teacher
  end

  private

  def set_default_values
    self.is_teacher ||= false
  end

  def fields_format
    self.username = username.downcase
  end
end
