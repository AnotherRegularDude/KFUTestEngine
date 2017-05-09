module MarkdownConvertible
  extend ActiveSupport::Concern

  def processed_html
    markdown_to_html(markdown_text)
  end

  def markdown_to_html(markdown_text)
    options = { autolink: true, tables: true }
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, **options).render(markdown_text)
  end
end
