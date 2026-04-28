require "faker"

Faker::Config.locale = "en"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
