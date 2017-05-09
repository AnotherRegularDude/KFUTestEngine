require 'test_helper'

class MaterialsControllerTest < ActionDispatch::IntegrationTest
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
end
