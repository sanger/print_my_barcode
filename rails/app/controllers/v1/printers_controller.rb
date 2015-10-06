class V1::PrintersController < ApplicationController

  def index
    render json: Printer.all
  end

  def show
    render json: current_resource
  end

  def create
    printer = Printer.new(printer_params)
    if printer.save
      render json: printer
    else
      render json: { errors: printer.errors }, status: :unprocessable_entity
    end
  end

protected

  def current_resource
    Printer.find(params[:id]) if params[:id]
  end

  def printer_params
    params.require(:printer).permit(:name)
  end
  
end