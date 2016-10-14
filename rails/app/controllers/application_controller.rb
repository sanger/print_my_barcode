class ApplicationController < ActionController::API

  include ActionController::Serialization

   # Ensure that the exception notifier is working. It will send an email to the standard email address.
  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end

  def render_error(resource, status: :unprocessable_entity)
    render json: resource, status: status, serializer: ActiveModel::Serializer::ErrorSerializer
  end

end