# frozen_string_literal: true

module V2
  # PrintJobsController
  class PrintJobsController < ApplicationController
    def create
      print_job_wrapper = PrintJobWrapper.new(print_job_params)
      # TODO: fix
      if print_job_wrapper.print
        render json: { message: 'labels successfully printed' }
      else
        render_error print_job_wrapper
      end
    end

    private

    # TODO: fix
    def print_job_params
      params.require(:print_job).permit(
        :printer_name,
        :label_template_name,
        :label_template_id,
        :copies,
        # labels: []
      )
    end
  end
end
