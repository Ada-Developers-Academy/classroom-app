# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize logging
Rails.logger = Logger.new(STDOUT)

Rails.logger.level = Logger::INFO # Default to INFO.

# Downcase the log level only if we've got one.
log_level = ENV['LOG_LEVEL']
log_level &&= ENV['LOG_LEVEL'].downcase

case log_level
when "fatal"
  Rails.logger.level = Logger::FATAL
when "error"
  Rails.logger.level = Logger::ERROR
when "warn"
  Rails.logger.level = Logger::WARN
when "info"
  Rails.logger.level = Logger::INFO
when "debug"
  Rails.logger.level = Logger::DEBUG
end



# Initialize the Rails application.
Rails.application.initialize!
