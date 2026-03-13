# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'v2/docs/index.html.erb', type: :view do
  context 'when release version is defined' do
    before do
      stub_const('Deployed::VERSION_ID', '1.2.3')
    end

    it 'renders the version in the title' do
      render

      expect(rendered).to include('<title>Print My Barcode (API V2) 1.2.3</title>')
    end

    it 'renders the version in the header' do
      render

      expect(rendered).to include('<h1 class="title">Print My Barcode (API V2) 1.2.3</h1>')
    end
  end

  context 'when release version is not defined' do
    before do
      stub_const('Deployed::VERSION_ID', 'WIP')
    end

    it 'renders WIP in the title' do
      render

      expect(rendered).to include('<title>Print My Barcode (API V2) WIP</title>')
    end

    it 'renders WIP in the header' do
      render

      expect(rendered).to include('<h1 class="title">Print My Barcode (API V2) WIP</h1>')
    end
  end

  context 'when the request base URL is defined' do
    before do
      allow(request).to receive(:base_url).and_return('http://example.com')
    end

    it 'renders the base URI in the properties section' do
      render

      expect(rendered).to include('<span class="property">base uri:</span> http://example.com/v2/')
    end
  end
end
