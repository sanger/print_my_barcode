# frozen_string_literal: true

module V2
  # PrintersController
  class PrintersController < ApplicationController
    def index
      render json: { printers: Printer.all }
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

    def printer_params
      params.require(:data).require(:attributes).permit(:name, :protocol, :printer_type)
    end
  end
end
