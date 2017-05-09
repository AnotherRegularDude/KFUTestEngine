json.meta do
  json.next_page path_to_next_page @topics
  json.prev_page path_to_prev_page @topics
end
json.data do
  json.topics @topics, partial: 'shared/topic', as: :topic
end
