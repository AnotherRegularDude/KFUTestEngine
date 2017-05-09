json.data do
  json.topic @topic, partial: 'shared/topic', as: :topic
  json.errors { json.partial! 'shared/model_errors', errors: @topic.errors }
end
