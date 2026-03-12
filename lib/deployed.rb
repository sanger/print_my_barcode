# frozen_string_literal: true

module Deployed
  class Release # rubocop:disable Style/Documentation
    def release_version
      @release_version = read_file('.release-version').strip.presence || 'WIP'
    end

    private

    def read_file(filename)
      Rails.root.join(filename).open('r', &:readline)
    rescue Errno::ENOENT, EOFError
      ''
    end
  end

  RELEASE = Release.new

  VERSION_ID = RELEASE.release_version
end
