ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# BROKE THINGS. Also has to change a bug un minitest. https://github.com/rails/rails/issues/31324
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
