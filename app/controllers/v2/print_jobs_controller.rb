# frozen_string_literal: true

module V2
  # PrintJobsController
  class PrintJobsController < ApplicationController
    # rubocop:disable Metrics/AbcSize
    def create
      Rails.logger.info { 'IN PrintJobsController' }
      Rails.logger.info { "Rails.logger.level #{Rails.logger.level}" }
      Rails.logger.level = 0
      Rails.logger.info { "Rails.logger.level #{Rails.logger.level}" }
      print_job_wrapper = PrintJobWrapper.new(print_job_params)

      if print_job_wrapper.print
        render json: { message: 'labels successfully printed' }
      else
        render_error print_job_wrapper
      end
    end
    # rubocop:enable Metrics/AbcSize

    private

    # rubocop:disable Metrics/AbcSize
    def print_job_params
      params.require(:print_job).permit(:printer_name, :label_template_name, :copies)
            .tap do |allow_listed|
        allow_listed[:labels] = []
        params[:print_job][:labels].each do |label|
          Rails.logger.level = 0
          Rails.logger.debug { "LIST #{allow_listed}" }
          Rails.logger.debug { "LABEL #{label}" }
          Rails.logger.debug { "LABEL PERMIT #{label.permit}" }
          allow_listed[:labels] << label.permit!
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
