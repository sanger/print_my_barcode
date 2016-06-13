module Filterable

  extend ActiveSupport::Concern

  class_methods do

    def before_filter(&block)
      @_before_filter = block
    end

    def filter(filters)
      filters = @_before_filter.call(filters) if @_before_filter
      where(filters)
    end

  end

end