# frozen_string_literal: true

module V2
  # PrintersController
  class PrintersController < ApplicationController
    def index
      render json: { printers: Printer.all }
    end
  end
end
