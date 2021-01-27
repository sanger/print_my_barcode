# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::PrintersController, type: :request do

  it 'should allow retrieval of all printers' do
    printers = create_list(:printer, 5)
    get v2_printers_path
    expect(response).to be_successful
    expect(ActiveSupport::JSON.decode(response.body)['printers'].length).to eq(printers.length)
  end

end
