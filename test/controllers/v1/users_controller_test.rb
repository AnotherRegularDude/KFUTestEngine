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

  test 'show information about one user' do
    user = create(:user)
    get v1_user_url(user)
    user_remote = response_body_to_json[:data][:user]

    assert_equal user.id, user_remote[:id]
    assert_equal user.fullname, user_remote[:fullname]
    assert_equal user.is_teacher, user_remote[:is_teacher]
  end

  test 'try get user, which does not exist' do
    get '/v1/users/10'
    data = response_body_to_json[:data]

    assert_not_nil data[:error]
  end

  test 'create new good user' do
    user = build(:user)
    hashed_user = user.attributes.merge(password: user.password)
    encoded_data = { user: hashed_user }.as_json
    post '/v1/users', params: encoded_data
    data = response_body_to_json[:data]

    assert_empty data[:errors]
    assert_not_empty data[:user]
    assert_equal user.first_name, data[:user][:first_name]
  end

  test 'create bad user with errors' do
    user = { username: 'only_this_shit' }
    post '/v1/users', params: { user: user }.as_json
    data = response_body_to_json[:data]

    assert_not_empty data[:errors]
  end

  test 'create two users with the same usernames' do
    user = create(:user)
    same_login = user.attributes.each { |key, value| { key => value.try(:upcase) } }
    post '/v1/users', params: { user: same_login }.as_json
    data = response_body_to_json[:data]

    assert_not_empty data[:errors]
  end

  test 'delete student account with teacher account' do
    student = create(:user)
    delete v1_user_url(student), headers: full_auth_helper.headers
    data = response_body_to_json[:data]

    assert_not_nil data[:user]
    assert_equal student.id, data[:user][:id]
    assert_nil data[:user][:password]
  end

  test 'delete student account with not permitted acc' do
    student = create(:user)
    delete v1_user_url(student), headers: full_auth_helper(factory_params: []).headers
    data = response_body_to_json[:data]

    assert_nil data[:user]
    assert_equal I18n.t('pundit.destroy?'), data[:error]
  end

  test 'delete student with bad auth token' do
    student = create(:user)
    delete v1_user_url(student), headers: { 'Authorization': 'abcd' }
    data = response_body_to_json[:data]

    assert_nil data[:user]
    assert_equal I18n.t('errors.login_required'), data[:error]
  end

  test 'delete user with auth token, wich have bad user id' do
    student = create(:user)
    auth_holder = full_auth_helper
    auth_holder.user.destroy
    delete v1_user_url(student), headers: auth_holder.headers
    data = response_body_to_json[:data]

    assert_nil data[:user]
    assert_equal I18n.t('errors.login_required'), data[:error]
  end

  test 'update information about students via self acc' do
    student = create(:user)
    encoded_data = { user: { first_name: 'AnotherName' } }.as_json
    put v1_user_url(student), params: encoded_data, headers: { 'Authorization': token_for(student) }
    data = response_body_to_json[:data]

    refreshed_stud = User.find_by(id: student.id)
    assert_not_nil data[:user]
    assert_empty data[:errors]
    assert_equal 'AnotherName', data[:user][:first_name]
    assert_not_equal student.first_name, refreshed_stud.first_name
  end

  test "update student acc from another teacher's acc" do
    student = create(:user)
    encoded_data = { user: { first_name: 'AnotherName' } }.as_json
    put v1_user_url(student), params: encoded_data, headers: full_auth_helper.headers
    data = response_body_to_json[:data]

    assert_not_nil data[:user]
    assert_equal 'AnotherName', data[:user][:first_name]
    assert_empty data[:errors]
  end

  test "can't update username and password fields" do
    student = create(:user)
    encoded_data = { user: { username: 'AnotherUsername', password: 'AnotherPassword' } }.as_json
    put v1_user_url(student), params: encoded_data, headers: { 'Authorization': token_for(student) }
    data = response_body_to_json[:data]

    refreshed_stud = User.find_by(id: student.id)
    assert_not_nil data[:user]
    assert_empty data[:errors]
    assert_equal student.username, refreshed_stud.username
    assert_equal student.password_digest, refreshed_stud.password_digest
  end

  test 'update different student acc via student acc' do
    edited_stud = create(:user)
    encoded_data = { user: { first_name: 'AnotherName' } }.as_json
    put v1_user_url(edited_stud), params: encoded_data,
                                  headers: full_auth_helper(factory_params: []).headers
    data = response_body_to_json[:data]

    assert_nil data[:user]
    assert_equal I18n.t('pundit.update?'), data[:error]
  end
end
