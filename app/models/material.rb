class Material < ApplicationRecord
  include MarkdownConvertible
  include ActionView::Helpers::SanitizeHelper

  belongs_to :topic

  alias_attribute :markdown_text, :text_in_markdown

  validates :short_description, length: { maximum: 255 }
  validates :text_in_markdown, presence: true, length: { minimum: 50 }

  before_save :format_short_description

  private

  def format_short_description
    self.short_description ||= strip_tags(processed_html).truncate(255)
    self.short_description = short_description.humanize
  end
end
