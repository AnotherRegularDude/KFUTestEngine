class ApplicationController < ActionController::API
  include Pundit

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
  rescue_from Pundit::NotAuthorizedError, with: :permissions_handler

  protected

  def check_authorized
    return if current_user.present?

    @message_path = 'errors.login_required'
    render 'v1/service_errors/basic_error', status: :unauthorized
  end

  def not_found_handler
    @message_path = 'errors.record_not_found'
    render 'v1/service_errors/basic_error', status: :not_found
  end

  def permissions_handler(exception)
    @message_path = "pundit.#{exception.query}"
    render 'v1/service_errors/basic_error', status: :unauthorized
  end

  def current_user
    Session.user_from_token request.headers.fetch('Authorization', '')
  end
end
