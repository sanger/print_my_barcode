# frozen_string_literal: true

module V1
  # PrintJobsController
  class PrintJobsController < ApplicationController
    def create
      print_job = LabelPrinter::PrintJob.build(print_job_params)
      if print_job.execute
        render json: print_job, serializer: PrintJobSerializer, status: :created
      else
        render_error print_job
      end
    end

    private

    def print_job_params
      params.require(:data).require(:attributes)
            .permit(:printer_name, :label_template_id)
            .tap do |whitelisted|
              whitelisted[:labels] = params[:data][:attributes][:labels].permit!
            end
    end
  end
end
