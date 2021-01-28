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
        render 'error'
        # render_error print_job_wrapper
      end
    end

    private

    def print_job_params
      p1 = params.permit(
        print_job: %i[
          printer_name
          label_template_name
          label_template_id
          copies
        ]
      )[:print_job].to_h

      p1.merge(labels: labels_params)
    end

    def labels_params
      params.require(:print_job)[:labels].map { |label| label.permit!.to_h }
    end
  end
end