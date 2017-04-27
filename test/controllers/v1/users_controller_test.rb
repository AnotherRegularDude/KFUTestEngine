require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    create_list(:user, 35)
    get v1_users_url
    data = response_body_to_json

    assert_equal 25, data[:data][:users].length
    assert_not_nil data[:meta][:next_page]
  end

  test 'get index with page parameter' do
    create_list(:user, 35)
    get v1_users_url, params: { page: 2 }
    data = response_body_to_json

    assert_not_nil data[:meta][:prev_page]
  end

  test 'get index with big page number' do
    get v1_users_url, params: { page: 2 }
    data = response_body_to_json

    assert_empty data[:data][:users]
  end
end
