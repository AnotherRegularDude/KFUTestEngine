module V1
  class MaterialsController < ApplicationController
    before_action :check_authorized, except: %i[index show]
    before_action :find_topic_by_id, except: %i[show]
    before_action :find_material_by_id, except: %i[index create]

    def index
      @materials = if @topic.present?
                     @topic.materials.order(:id).page params[:page]
                   else
                     Material.order(:id).page params[:page]
                   end

      render 'index'
    end

    def show
      render 'show'
    end

    def create
      authorize Material

      @material = @topic.materials.new(material_params)
      if @material.save
        render 'create'
      else
        render 'create', status: :bad_request
      end
    end

    def update
      authorize @material

      if @material.update(material_params)
        render 'create'
      else
        render 'create', status: :bad_request
      end
    end

    def destroy
      authorize @material

      @material.destroy
      render 'destroy'
    end

    private

    def material_params
      params.require(:material).permit(:short_description, :text_in_markdown)
    end

    def find_topic_by_id
      topic_id = params[:topic_id]
      @topic = Topic.find_by!(id: topic_id) if topic_id.present?
    end

    def find_material_by_id
      material_id = params[:id]
      @material = if @topic.present?
                    @topic.materials.find_by!(id: material_id)
                  else
                    Material.find_by!(id: material_id)
                  end
    end
  end
end
