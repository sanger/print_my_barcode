class V1::PrintersController < ApplicationController

  def index
    render json: Printer.where(query_params[:filter])
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
    params.require(:data).require(:attributes).permit(:name)
  end

  def query_params
    query_params = params.permit(filter: [:name, :protocol])

    if query_params.try(:filter).try(:protocol)
      query_params[:filter][:protocol] = Printer.protocols[query_params[:filter][:protocol]]
    end

    query_params
  end

end