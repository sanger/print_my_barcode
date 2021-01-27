# frozen_string_literal: true

module V2
  # PrintJobsController
  class PrintJobsController < ApplicationController
    def create
      print_job_wrapper = PrintJobWrapper.new(print_job_params)
      if print_job_wrapper.valid?
        render json: { message: 'labels successfully printed' }
      else
        render_error print_job_wrapper
      end
    end

    private

    def print_job_params
      params.require(:print_job).permit(:printer_name, :label_template_name)
    end
  end
end
