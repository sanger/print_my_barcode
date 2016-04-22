require "test_helper"

class PrintJobTest < ActiveSupport::TestCase
    include ActiveModel::Lint::Tests

    def setup
       @model = FactoryGirl.build(:print_job)
    end

end

