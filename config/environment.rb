Dir['./models/*.rb'].each {|file| require file}
# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
