json.extract! material, :id, :short_description, :created_at, :updated_at
json.extract! material, :processed_html if full_show && material.text_in_markdown.present?
