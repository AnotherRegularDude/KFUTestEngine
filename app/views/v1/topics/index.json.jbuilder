json.meta do
  json.next_page path_to_next_page @topics
  json.prev_page path_to_prev_page @topics
end
json.data do
  json.topics @topics do |topic|
    json.partial! 'shared/topic', topic: topic
  end
end
