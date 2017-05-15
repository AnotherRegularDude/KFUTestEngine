json.data do
  json.material { json.partial! 'shared/material', material: @material, full_show: true }
  json.topic { json.partial!  'shared/topic', topic: @material.topic }
end
