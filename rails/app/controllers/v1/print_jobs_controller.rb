class V1::PrintJobsController < ApplicationController

  def create
    print_job = LabelPrinter::PrintJob.build(print_job_params)
    if print_job.execute
      render json: print_job, serializer: PrintJobSerializer, status: :created
    else
      render json: { errors: print_job.errors }, status: :unprocessable_entity
    end
  end

private

  def print_job_params
    permitted_params = params.require(:data).require(:attributes).permit(:printer_name, :label_template_id).tap do |whitelisted|
      whitelisted[:labels] = params[:data][:attributes][:labels]
    end
  end

end
