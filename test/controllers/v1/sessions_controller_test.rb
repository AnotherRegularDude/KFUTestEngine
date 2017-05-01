require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'login via existing user' do
    user = create(:user)
    encoded_data = {
      user: {
        username: user.username,
        password: user.password
      }
    }.as_json
    post '/v1/sessions', params: encoded_data
    data = response_body_to_json[:data]

    assert_empty data[:errors]
    assert_not_nil data[:session][:token]
  end

  test 'login with bad credentials' do
    user = create(:user)
    encoded_data = {
      user: {
        username: user.username,
        password: 'bad_password'
      }
    }.as_json
    post '/v1/sessions', params: encoded_data
    data = response_body_to_json[:data]

    assert_not_nil data[:errors]
    assert_nil data[:session][:token]
  end
end
