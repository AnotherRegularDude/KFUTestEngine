json.data do
  json.material @material, partial: 'shared/material', as: :material
  json.errors { json.partial! 'shared/model_errors', errors: @material.errors }
end
json.include do
  json.topic @topic, partial: 'shared/topic', as: :topic
end
