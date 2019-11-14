# require 'spree/testing_support/preferences'
# require 'spree/core/controller_helpers/strong_parameters'

require 'spree/testing_support/factories'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/flash'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/capybara_ext'

RSpec.configure do |config|
  # config.include Spree::TestingSupport::Preferences
  # config.include Spree::Core::ControllerHelpers::StrongParameters, type: :controller
  config.include Spree::TestingSupport::ControllerRequests, type: :controller
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::Flash
end
