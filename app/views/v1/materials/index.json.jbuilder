json.meta do
  json.next_page path_to_next_page @materials
  json.prev_page path_to_prev_page @materials
end
json.data do
  json.topic @topic, partial: 'shared/topic', as: :topic if @topic.present?
  json.materials @materials, partial: 'shared/material', as: :material, locals: { full_show: false }
end
