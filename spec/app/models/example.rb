require "#{File.dirname(__FILE__)}/../support/example_definition.rb"

class Example
  include ExampleDefinition

  def initialize
    callmeback!
    self.result = []
  end
end
