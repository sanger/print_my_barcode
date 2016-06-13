class V1::LabelTemplatesController < ApplicationController

  #'**' includes all nested associated resources in the "included" member

  def index
    render json: LabelTemplate.filter(filter_parameters[:filter]), include: '**'
  end

  def show
    render json: current_resource, include: '**'
  end

  def create
    label_template = LabelTemplate.new label_template_params
    if label_template.save
      render json: label_template, include: '**'
    else
      render json: { errors: label_template.errors }, status: :unprocessable_entity
    end
  end

  def update
    label_template = current_resource
    if label_template.update_attributes(label_template_params)
      render json: label_template, include: '**'
    else
      render json: { errors: label_template.errors }, status: :unprocessable_entity
    end
  end

private

  def current_resource
    LabelTemplate.find(params[:id]) if params[:id]
  end

  def label_template_params
    params.require(:data).require(:attributes).permit(LabelTemplate.permitted_attributes)
  end

  def filter_parameters
    params.permit(filter: [:name])
  end

end