class ApplicationController < ActionController::API

  include Pundit
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
  rescue_from JWE::DecodeError, with: :guest_handler
  rescue_from Pundit::NotAuthorizedError, with: :permissions_handler

  protected

  def not_found_handler
    @message_path = 'errors.not_found'
    render 'v1/service_errors/basic_error', status: :not_found
  end

  def permissions_handler
    @message_path = 'errors.not_authorized'
    render 'v1/service_errors/basic_error', status: :unauthorized
  end

  def guest_handler
    @message_path = 'errors.login_required'
    render 'v1/service_errors/basic_error', status: :unauthorized
  end

  def current_user
    session = Session.new(token: request.headers.fetch('Authorization', ''))
    session.user_from_token
  end
end
