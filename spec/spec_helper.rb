$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require "active_record"
ActiveRecord::Base.establish_connection :adapter => :nulldb, :schema  => File.join(File.dirname(__FILE__), "app", "db", "schema.rb")

MODELS = File.join(File.dirname(__FILE__), "app/models")

require 'rspec'
require 'active_support/inflector'
require 'callmeback'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, file
end

RSpec.configure do |config|
  
end
