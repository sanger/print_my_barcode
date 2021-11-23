# frozen_string_literal: true

module V2
  # PrintersController
  # The code here is exactly the same as v1. I tried to use a concern
  # but for some strange reason it does not include
  # the create action! As ever something that should be
  # simple is not with no discernable reason why.
  class PrintersController < ApplicationController
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
      params.require(:data).require(:attributes).permit(:name, :protocol, :printer_type)
    end

    def filter_params
      params.permit(filter: %i[name protocol printer_type])
    end
  end
end
