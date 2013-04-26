require "active_record"
require "#{File.dirname(__FILE__)}/../support/example_definition.rb"

class ExampleActiveRecord < ActiveRecord::Base
  include ExampleDefinition

  after_initialize do
    callmeback!
    self.result = []
  end
end
