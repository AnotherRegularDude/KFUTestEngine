require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test 'teacher create valid topic' do
    teacher = create(:user, :teacher)
    topic = build(:topic)
    encoded_data = { topic: topic }.as_json
    post '/v1/topics', params: encoded_data, headers: auth_headers_for(teacher)
    data = response_body_to_json[:data]

    assert_not_nil data[:topic]
    assert_equal topic.short_description, data[:topic][:short_description]
    assert_equal topic.title.humanize, data[:topic][:title]
    assert_empty data[:errors]
  end

  test 'teacher try to create not valid topic' do
    teacher = create(:user, :teacher)
    topic = build(:topic)
    topic.title = ''
    encoded_data = { topic: topic }.as_json
    post '/v1/topics', params: encoded_data, headers: auth_headers_for(teacher)
    data = response_body_to_json[:data]

    assert_not_nil data[:topic]
    assert_not_empty data[:errors]
  end

  test 'not permitted student try to create topic' do
    student = create(:user)
    topic = build(:topic)
    encoded_data = { topic: topic }.as_json
    post '/v1/topics', params: encoded_data, headers: auth_headers_for(student)
    data = response_body_to_json[:data]

    assert_equal I18n.t('pundit.create?'), data[:error]
  end

  test 'guest try to create topic' do
    topic = build(:topic)
    encoded_data = { topic: topic }.as_json
    post '/v1/topics', params: encoded_data
    data = response_body_to_json[:data]

    assert_equal I18n.t('errors.login_required'), data[:error]
  end
end
