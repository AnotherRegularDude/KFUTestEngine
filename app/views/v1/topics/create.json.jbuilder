json.data do
  json.topic @topic, partial: 'shared/topic', as: :topic
  json.errors @topic.errors
end
