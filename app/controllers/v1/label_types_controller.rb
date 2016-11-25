class V1::LabelTypesController < ApplicationController

  def index
    render json: LabelType.filter(filter_params[:filter])
  end

  def show
    render json: current_resource
  end

  def create
    label_type = LabelType.new label_type_params
    if label_type.save
      render json: label_type, status: :created
    else
      render_error label_type
    end
  end

  def update
    label_type = current_resource
    if label_type.update_attributes(label_type_params)
      render json: label_type
    else
      render_error label_type
    end
  end

private

  def current_resource
    LabelType.find(params[:id]) if params[:id]
  end

  def label_type_params
    params.require(:data).require(:attributes).permit(:name, :feed_value, :fine_adjustment,:pitch_length, :print_width,:print_length)
  end

  def filter_params
    params.permit(filter: [:name])
  end

end