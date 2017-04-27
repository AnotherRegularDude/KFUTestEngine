module V1
  class UsersController < ApplicationController
    before_action :find_by_id, only: [:show]

    def index
      @users = User.page params[:page]
      render 'index'
    end

    def show
      render 'show'
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render 'create'
      else
        render 'create', status: :bad_request
      end
    end

    private

    def user_params
      params.require(:user).permit(:username, :password, :first_name, :last_name, :patronymic)
    end

    def find_by_id
      @user = User.find_by!(id: params[:id])
    end
  end
end
