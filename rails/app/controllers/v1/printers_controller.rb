class V1::PrintersController < ApplicationController

  def index
    render json: Printer.filter(filter_params[:filter])
  end

  def show
    render json: current_resource
  end

  def create
    printer = Printer.new(printer_params)
    if printer.save
      render json: printer, status: :created
    else
      render_error printer
    end
  end

protected

  def current_resource
    Printer.find(params[:id]) if params[:id]
  end

  def printer_params
    params.require(:data).require(:attributes).permit(:name, :protocol)
  end

  def filter_params
    params.permit(filter: [:name, :protocol])
  end

end