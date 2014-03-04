require 'pulla'
require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
WebMock.disable_net_connect!

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)).each do |path|
  require path
end
