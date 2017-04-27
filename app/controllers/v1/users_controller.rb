module V1
  class UsersController < ApplicationController
    def index
      @users = User.all
      paginate @users
    end

    def show
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render 'create', status: :created
      else
        render 'create', status: :bad_request
      end
    end

    private

    def user_params
      params.require(:data).permit(:username, :password, :first_name, :second_name, :patronymic)
    end
  end
end
