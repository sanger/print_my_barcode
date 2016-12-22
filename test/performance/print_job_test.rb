require 'test_helper'
require 'rails/performance_test_help'

class PrintJobTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  attr_reader :label_template, :printer, :print_job_params

  def setup
    @label_template = create(:label_template)
    @printer = create(:printer)
    @print_job_params =  {"data" => { 
                          "attributes" => {
                          "printer_name" => printer.name,
                          "label_template_id" => label_template.id,
                          "labels" => label_template.dummy_labels.to_h
                              }
                            }
                          }
  end

  test "print job" do
    LabelPrinter::PrintJob::LPD.any_instance.stubs(:execute).returns(true)
    post '/v1/print_jobs', print_job_params.to_json, {'ACCEPT' => "application/vnd.api+json", 'CONTENT_TYPE' => "application/vnd.api+json"}
  end
end
