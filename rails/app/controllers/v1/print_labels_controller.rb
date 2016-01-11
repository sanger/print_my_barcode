class V1::PrintLabelsController < ApplicationController

  def create
    print_label = PrintLabel.new(params[:print_label])
    if print_label.run
      render json: print_label
    else
      render json: { errors: print_label.errors }, status: :unprocessable_entity
    end
  end

end