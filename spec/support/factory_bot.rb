RSpec.configure do |config|
  config.include Capybara::DSL
  config.include FactoryBot::Syntax::Methods
end
