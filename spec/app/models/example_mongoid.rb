require "mongoid"
require "#{File.dirname(__FILE__)}/../support/example_definition.rb"

class ExampleMongoid
  include Mongoid::Document
  include ExampleDefinition

  after_initialize do
    callmeback!
    self.result = []
  end
end
