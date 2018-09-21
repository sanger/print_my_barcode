# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::DocsController, type: :request do

  it 'shows me some crazy data' do
    get v1_docs_path
    expect(response).to be_successful
    expect(response.body).to include('Print My Barcode')
  end
  
end
