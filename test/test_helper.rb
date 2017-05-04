ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']

Minitest::Reporters.use!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def response_body_to_json
    JSON.parse(@response.body, symbolize_names: true)
  end

  def token_for(user)
    session = Session.new(username: user.username, password: user.password)
    session.create_token

    session.token
  end

  def auth_headers_for(user)
    { 'Authorization': token_for(user) }
  end
  # Add more helper methods to be used by all tests here...
end
