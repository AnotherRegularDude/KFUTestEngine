json.data do
  json.material { json.partial! 'shared/material', material: @material, full_show: false }
  json.topic { json.partial! 'shared/topic', topic: @topic }
end
