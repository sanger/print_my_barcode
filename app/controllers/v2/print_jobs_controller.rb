# frozen_string_literal: true

module V2
  # PrintJobsController
  class PrintJobsController < ApplicationController
    def create
      print_job_wrapper = PrintJobWrapper.new(print_job_params)

      if print_job_wrapper.print
        render json: { message: 'labels successfully printed' }
      else
        render_error print_job_wrapper
      end
    end

    private

    def print_job_params
      params.expect(print_job: %i[printer_name label_template_name copies])
            .tap do |allow_listed|
        allow_listed[:labels] = []
        params[:print_job][:labels].each do |label|
          allow_listed[:labels] << label.permit!
        end
      end
    end
  end
end
