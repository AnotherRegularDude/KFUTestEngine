module V1
  class TopicsController < ApplicationController
    before_action :check_authorized, only: %i[create update destroy]
    before_action :find_by_id, except: %i[index create]

    def index
      @topics = Topic.page params[:page]
      render 'index'
    end

    def show
      render 'show'
    end

    def create
      authorize Topic

      @topic = Topic.new(topic_params)
      if @topic.save
        render 'create'
      else
        render 'create', status: :bad_request
      end
    end

    def update
      authorize @topic

      if @topic.update(topic_params)
        render 'create', status: :accepted
      else
        render 'create', status: :bad_request
      end
    end

    def destroy
      authorize @topic

      @topic.destroy
      render 'destroy'
    end

    private

    def find_by_id
      @topic = Topic.find_by!(id: params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :short_description, :questions_per_test)
    end
  end
end
