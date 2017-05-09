json.data do
  json.topic { json.partial! 'shared/topic', topic: @topic }
end
