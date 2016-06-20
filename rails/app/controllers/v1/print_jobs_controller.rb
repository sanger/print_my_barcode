class V1::PrintJobsController < ApplicationController

  def create
    print_job = LabelPrinter::PrintJob.build(params["data"]["attributes"])
    if print_job.execute
      render json: print_job, serializer: PrintJobSerializer
    else
      render_error print_job
    end
  end

end
