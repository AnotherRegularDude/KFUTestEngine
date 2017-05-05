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
    student = create(:user)
    get v1_topics_url, headers: auth_headers_for(student)
    data = response_body_to_json

    assert_not_empty data[:meta]
    assert_not_empty data[:data][:topics]
    assert_nil data[:data][:topics][1][:questions_per_test]
  end

  test 'index topics via teacher' do
    create_list(:topic, 51)
    teacher = create(:user, :teacher)
    get v1_topics_url, headers: auth_headers_for(teacher)
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
    post_with_params(custom_title: '')
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

  private

  def post_with_params(options = {})
    use_headers = options.fetch(:use_headers, true)
    factory_params = options.fetch(:factory_params, [:teacher])
    custom_title = options.fetch(:custom_title, nil)
    topic, encoded_data = generate_topic_with_data(custom_title)
    post_with_options(use_headers, factory_params, encoded_data)

    topic
  end

  def generate_topic_with_data(custom_title)
    topic = build(:topic)
    topic.title = custom_title unless custom_title.nil?
    encoded_data = { topic: topic }.as_json

    [topic, encoded_data]
  end

  def post_with_options(use_headers, factory_params, encoded_data)
    if use_headers
      auth_user = create(:user, *factory_params)
      post '/v1/topics', params: encoded_data, headers: auth_headers_for(auth_user)
    else
      post '/v1/topics', params: encoded_data
    end
  end
end
