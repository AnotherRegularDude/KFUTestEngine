class Material < ApplicationRecord
  include MarkdownConvertible

  belongs_to :topic

  alias_attribute :markdown_text, :text_in_markdown

  validates :short_description, length: { maximum: 255 }
  validates :text_in_markdown, presence: true, length: { minimum: 50 }

  before_save :format_short_description

  private

  def format_short_description
    @short_description ||= text_in_markdown.humanize.truncate_words(255)
  end
end
