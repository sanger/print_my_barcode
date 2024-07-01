# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V2::DocsController, type: :request do

  it 'should render the documentation' do
    get v2_docs_path
    expect(response).to be_successful
    expect(response.body).to include('Print My Barcode (API V2)')
  end

end
