class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler

  private

  def not_found_handler
    render 'v1/service_errors/not_found', status: :not_found
  end
end
