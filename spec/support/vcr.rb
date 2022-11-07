require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock

  config.default_cassette_options = {
    match_requests_on: %i[
      method
      path
      body
    ],
  }

  config.configure_rspec_metadata!
end
