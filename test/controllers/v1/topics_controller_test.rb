require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test 'index topics via guest' do
    create_list(:topic, 51)
    get v1_topics_url
    data = response_body_to_json

    assert_not_empty data[:meta]
    assert_not_empty data[:data][:topics]
    assert_nil data[:data][:topics][1][:questions_per_test]
  end

  test 'index via student' do
    create_list(:topic, 51)
    get v1_topics_url, headers: full_auth_helper(factory_params: []).headers
    data = response_body_to_json

    assert_not_empty data[:meta]
    assert_not_empty data[:data][:topics]
    assert_nil data[:data][:topics][1][:questions_per_test]
  end

  test 'index topics via teacher' do
    create_list(:topic, 51)
    get v1_topics_url, headers: full_auth_helper.headers
    data = response_body_to_json

    assert_not_empty data[:meta]
    assert_not_empty data[:data][:topics]
    assert_not_nil data[:data][:topics][1][:questions_per_test]
  end

  test 'teacher create valid topic' do
    topic = post_with_params
    data = response_body_to_json[:data]

    assert_not_nil data[:topic]
    assert_equal topic.short_description, data[:topic][:short_description]
    assert_equal topic.title.humanize, data[:topic][:title]
    assert_empty data[:errors]
  end

  test 'teacher try to create not valid topic' do
    post_with_params { |topic| topic.title = '' }
    data = response_body_to_json[:data]

    assert_not_nil data[:topic]
    assert_not_empty data[:errors]
  end

  test 'not permitted student try to create topic' do
    post_with_params(factory_params: [])
    data = response_body_to_json[:data]

    assert_equal I18n.t('pundit.create?'), data[:error]
  end

  test 'guest try to create topic' do
    post_with_params(use_headers: false)
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.login_required'), data[:error]
  end

  test 'teacher update existed topic with valid values' do
    topic = put_with_params { |item| item.title = 'Unique Changed Topic' }
    data = response_body_to_json[:data]

    assert_empty data[:errors]
    assert_not_equal topic.title, data[:topic][:title]
  end

  test 'teacher update topic with not unique title' do
    topic = put_with_params { |item| item.title = create(:topic).title }
    data = response_body_to_json[:data]

    assert_not_empty data[:errors]
    assert_equal topic.title, Topic.find_by(id: topic.id).title
  end

  test 'not permitted student update topic' do
    topic = put_with_params(factory_params: []) { |item| item.title = 'Unique Title' }
    data = response_body_to_json[:data]

    assert_nil data[:topic]
    assert_equal I18n.t('pundit.update?'), data[:error]
    assert_equal topic.title, Topic.find_by(id: topic.id).title
  end

  test 'guest update topic ' do
    topic = put_with_params(use_headers: false) { |item| item.title = 'Unique Title' }
    data = response_body_to_json[:data]

    assert_nil data[:topic]
    assert_equal I18n.t('errors.login_required'), data[:error]
    assert_equal topic.title, Topic.find_by(id: topic.id).title
  end

  test 'update not existed topic' do
    put_with_params { |item| item.id = 9999 }
    data = response_body_to_json[:data]

    assert_nil data[:topic]
    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'show existed topic' do
    topic = create(:topic)
    get v1_topic_url(topic)
    data = response_body_to_json[:data]

    assert_not_empty data[:topic]
    assert_equal topic.id, data[:topic][:id]
  end

  test 'show not existed topic' do
    get '/v1/topics/9999'
    data = response_body_to_json[:data]

    assert_nil data[:topic]
    assert_equal I18n.t('errors.record_not_found'), data[:error]
  end

  test 'destroy existed topic with teacher acc' do
    topic = create(:topic)
    destroy_with_params(topic)
    data = response_body_to_json[:data]

    assert_not_empty data[:topic]
    assert_nil Topic.find_by(id: topic.id)
  end

  test 'destroy existed topic with student acc' do
    topic = create(:topic)
    destroy_with_params(topic, factory_params: [])
    data = response_body_to_json[:data]

    assert_nil data[:topic]
    assert_equal I18n.t('pundit.destroy?'), data[:error]
  end

  private

  def post_with_params(use_headers: true, factory_params: [:teacher], &topic_manipulator)
    topic, encoded_data = generate_topic_with_data(&topic_manipulator)
    if use_headers
      post '/v1/topics', params: encoded_data,
                         headers: full_auth_helper(factory_params: factory_params).headers
    else
      post '/v1/topics', params: encoded_data
    end

    topic
  end

  def put_with_params(use_headers: true, factory_params: [:teacher])
    topic = create(:topic)
    yield topic if block_given?
    encoded_data = { topic: topic.attributes.slice(*topic.changed) }.as_json
    headers = use_headers ? full_auth_helper(factory_params: factory_params).headers : nil
    put v1_topic_url(topic), params: encoded_data, headers: headers

    topic.restore_attributes
    topic
  end

  def destroy_with_params(topic, use_headers: true, factory_params: [:teacher])
    headers = use_headers ? full_auth_helper(factory_params: factory_params).headers : nil

    delete v1_topic_url(topic), headers: headers
  end

  def generate_topic_with_data
    topic = build(:topic)
    yield(topic) if block_given?
    encoded_data = { topic: topic }.as_json

    [topic, encoded_data]
  end
end
