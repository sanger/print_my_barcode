# frozen_string_literal: true

module V1
  # DocsController
  class DocsController < ActionController::Base
    def index
      render layout: false
    end
  end
end
