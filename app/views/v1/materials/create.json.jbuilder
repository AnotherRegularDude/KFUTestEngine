json.data do
  json.material { json.partial! 'shared/material', material: @material, full_show: true }
  json.errors { json.partial! 'shared/model_errors', errors: @material.errors }
end
json.include do
  json.topic @topic, partial: 'shared/topic', as: :topic
end
