# frozen_string_literal: true

module V1
  class DocsController < ApplicationController
    def index
      render layout: false
    end
  end
end
