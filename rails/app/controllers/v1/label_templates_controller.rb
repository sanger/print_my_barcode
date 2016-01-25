class V1::LabelTemplatesController < ApplicationController

  def index
    render json: LabelTemplate.all
  end

  def show
    render json: current_resource
  end

  def create
    label_template = LabelTemplate.new label_template_params
    if label_template.save
      render json: label_template
    else
      render json: { errors: label_template.errors }, status: :unprocessable_entity
    end
  end

  def update
    label_template = current_resource
    if label_template.update_attributes(label_template_params)
      render json: label_template
    else
      render json: { errors: label_template.errors }, status: :unprocessable_entity
    end
  end

private

  def current_resource
    LabelTemplate.find(params[:id]) if params[:id]
  end

  def label_template_params
    params.require(:label_template).permit(LabelTemplate.permitted_attributes)
  end
  
end