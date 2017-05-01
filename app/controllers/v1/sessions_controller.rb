module V1
  class SessionsController < ApplicationController
    def create
      @session = Session.new(session_params)

      if @session.create_token
        render 'create'
      else
        render 'create', status: :bad_request
      end
    end

    private

    def session_params
      params.require(:user).permit(:username, :password)
    end
  end
end
