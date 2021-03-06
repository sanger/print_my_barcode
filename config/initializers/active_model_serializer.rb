# frozen_string_literal: true

api_mime_types = %w[
  application/vnd.api+json
  text/x-json
  application/json
]

Mime::Type.unregister :json
Mime::Type.register 'application/json', :json, api_mime_types

ActiveModel::Serializer.config.adapter = :json_api
ActiveModel::Serializer.config.key_transform = :underscore
