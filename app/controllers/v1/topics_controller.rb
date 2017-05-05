module V1
  class TopicsController < ApplicationController
    before_action :check_authorized, only: %i[create]

    def index
      @topics = Topic.page params[:page]
      render 'index'
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

    private

    def topic_params
      params.require(:topic).permit(:title, :short_description, :questions_per_test)
    end
  end
end
