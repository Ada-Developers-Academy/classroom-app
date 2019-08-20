# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize logging
Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::DEBUG
config.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")

# Initialize the Rails application.
Rails.application.initialize!
