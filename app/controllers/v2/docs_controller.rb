# frozen_string_literal: true

module V2
  # DocsController
  # rubocop:disable-next Rails/ApplicationController
  class DocsController < ActionController::Base
    def index
      render layout: false
    end
  end
end
