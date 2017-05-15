require 'test_helper'

class MaterialsControllerTest < ActionDispatch::IntegrationTest
  test 'index materials without teacher' do
    create(:topic_with_materials, materials_count: 51)

    get v1_materials_url
    data = response_body_to_json

    assert_equal 25, data[:data][:materials].count
    assert_not_nil data[:meta][:next_page]
  end

  test 'index with big page' do
    get v1_materials_url, params: { page: 5 }
    data = response_body_to_json

    assert_empty data[:data][:materials]
    assert_empty data[:meta]
  end

  test 'index on topic' do
    create(:topic_with_materials, materials_count: 40)
    topic = create(:topic_with_materials, materials_count: 14)

    get v1_topic_materials_url(topic)
    data = response_body_to_json

    assert_equal topic.materials.count, data[:data][:materials].count
    assert_equal topic.id, data[:data][:topic][:id]
    assert_empty data[:meta]
  end

  test 'index on unexisted topic' do
    topic = build(:topic)

    get "/v1/topics/#{topic.id}/materials"
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'teacher create work material for topic' do
    topic = post_with_params
    material = topic.materials.first
    data = response_body_to_json[:data]

    assert_equal topic, material.topic
    assert_equal material.id, data[:material][:id]
  end

  test 'not permitted student try to create material' do
    topic = post_with_params(user_type: :student)
    data = response_body_to_json[:data]

    assert_empty topic.materials
    assert_not_nil data[:error]
  end

  test 'create material for topic which does not exist' do
    topic_id = 1
    post_with_params { |*args| topic_id += args[0].id -= 1 }
    data = response_body_to_json[:data]

    assert_empty Material.where(topic_id: topic_id)
    assert_not_nil data[:error]
  end

  test 'create not valid vmaterial for topic' do
    topic = post_with_params { |*args| args[1].text_in_markdown = '' }
    data = response_body_to_json

    assert_empty topic.materials
    assert_not_nil data[:data][:material]
    assert_equal topic.id, data[:include][:topic][:id]
    assert_not_nil data[:data][:errors]
  end

  test 'show existed material info' do
    material = create(:material, :with_rand_topic)
    get v1_material_url(material)
    data = response_body_to_json[:data]

    assert_equal material.id, data[:material][:id]
    assert_equal material.topic.id, data[:topic][:id]
    assert_not_nil data[:material][:processed_html]
  end

  test 'show not existed material' do
    get '/v1/materials/99999'
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'update material with existed topic' do
    new_desc = 'My short description'
    material = put_with_params { |item| item.short_description = new_desc }
    data = response_body_to_json[:data]

    assert_equal new_desc, data[:material][:short_description]
    assert_equal new_desc, material.short_description
  end

  test 'update material with not existed topic' do
    put_with_params { |item| item.topic.id = 9999 }
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'update material wich does not belong to topic' do
    topic = create(:topic)
    material = create(:material, :with_rand_topic)

    put "/v1/topics/#{topic.id}/materials/#{material.id}", headers: full_auth_helper.headers
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'destroy material from existed topic' do
    topic = create(:topic_with_materials)
    material = topic.materials.first
    material_count = topic.materials.count

    delete "/v1/topics/#{topic.id}/materials/#{material.id}", headers: full_auth_helper.headers
    data = response_body_to_json[:data]

    assert_equal topic.id, data[:topic][:id]
    assert_equal material_count - 1, topic.materials.count
  end

  private

  def post_with_params(use_headers: true, user_type: :teacher)
    topic = create(:topic)
    material = build(:material)
    yield(topic, material) if block_given?

    headers = use_headers ? full_auth_helper(factory_params: [user_type]).headers : nil
    params = { material: material }.as_json
    post "/v1/topics/#{topic.id}/materials", params: params, headers: headers

    Topic.find_by(id: topic.id)
  end

  def put_with_params(use_headers: true, user_type: :teacher)
    material = create(:material, :with_rand_topic)
    yield material if block_given?
    topic_id = material.topic.id

    headers = use_headers ? full_auth_helper(factory_params: [user_type]).headers : nil
    params = { material: material.attributes.slice(*material.changed) }.as_json
    put "/v1/topics/#{topic_id}/materials/#{material.id}", params: params, headers: headers

    Material.find_by(id: material.id)
  end
end
