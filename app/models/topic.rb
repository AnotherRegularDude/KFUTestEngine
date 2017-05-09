class Topic < ApplicationRecord
  MIN_NUMBER_OF_QUESTIONS = 2

  has_many :materials, dependent: :destroy

  validates :title, presence: true, length: { maximum: 40 }, uniqueness: true
  validates :short_description, length: { maximum: 255 }
  validates :questions_per_test, numericality: {
    only_integer: true,
    greater_than: 0,
    less_than_or_equal_to: 50
  }

  after_initialize :set_defaults
  before_validation :fields_format

  private

  def set_defaults
    self.questions_per_test ||= MIN_NUMBER_OF_QUESTIONS
  end

  def fields_format
    self.title = title.humanize
  end
end
