require 'rails_helper'

RSpec.describe Deployed::Release do
  let(:release) { described_class.new }

  def create_test_file(filename, content)
    allow(Rails.root).to receive(:join).with(filename).and_return(Pathname.new('/tmp/' + filename))
    allow_any_instance_of(Pathname).to receive(:open).with('r').and_yield(StringIO.new("#{content}\n"))
  end

  describe '#release_version' do
    before do
      create_test_file('.release-version', release_version_content)
    end

    context 'when .release-version file exists and has content' do
      let(:release_version_content) { '1.2.3' }

      it 'returns the version from the file' do
        expect(release.release_version).to eq('1.2.3')
      end
    end

    context 'when .release-version file does not exist' do
      let(:release_version_content) { nil }

      it 'returns WIP' do
        expect(release.release_version).to eq('WIP')
      end
    end

    context 'when .release-version file is empty' do
      let(:release_version_content) { '' }

      it 'returns WIP' do
        expect(release.release_version).to eq('WIP')
      end
    end
  end
end
