ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'parallel_tests/test/runtime_logger' if ENV['RECORD_RUNTIME']

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  class AuthDataHolder
    attr_accessor :user, :token, :headers

    class << self
      def create
        yield new
      end
    end
  end

  def response_body_to_json
    JSON.parse(@response.body, symbolize_names: true)
  end

  def full_auth_helper(factory_params: [:teacher])
    AuthDataHolder.create do |auth_holder|
      auth_holder.user = create(:user, *factory_params)
      auth_holder.token = token_for auth_holder.user
      auth_holder.headers = auth_headers_for auth_holder.token

      auth_holder
    end
  end

  private

  def token_for(user)
    session = Session.new(username: user.username, password: user.password)
    session.create_token

    session.token
  end

  def auth_headers_for(token)
    { 'Authorization': token }
  end
  # Add more helper methods to be used by all tests here...
end
