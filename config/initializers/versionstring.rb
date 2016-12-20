begin
  require 'deployed_version'
rescue LoadError
  module Deployed
    VERSION_ID = 'LOCAL'
  end
end