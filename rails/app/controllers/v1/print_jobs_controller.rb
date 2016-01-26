class V1::PrintJobsController < ApplicationController

  def create
    print_job = LabelPrinter::PrintJob.build(params[:print_job])
    if print_job.execute
      render json: print_job, serializer: PrintJobSerializer
    else
      render json: { errors: print_job.errors }, status: :unprocessable_entity
    end
  end

end