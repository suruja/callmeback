class Example
  include Callmeback

  attr_accessor :result

  before :before_foo => :bar
  after :after_foo => :bar
  around :around_foo => :around_bar

  before :multiple_before_foo => [:bar, :bar]
  after :multiple_after_foo => [:bar, :bar]
  around :multiple_around_foo => [:around_bar, :around_bar]

  before :complex_foo => :bar
  around :complex_foo => [:around_bar, :around_bar]
  after :complex_foo => [:bar, :bar]

  before( /^regex_before_.+$/ => :bar )

  before :block_before_foo do
    bar
  end

  after :block_after_foo do
    bar
  end

  around :block_around_foo do |&block|
    bar
    block.call
    bar
  end

  before :complex_with_blocks_foo do
    bar
    bar
  end
  after :complex_with_blocks_foo do
    bar
  end
  around :complex_with_blocks_foo do |&block|
    bar
    block.call
    bar
  end

  before :complex_with_methods_and_blocks_foo => [:bar, :bar]
  after :complex_with_methods_and_blocks_foo do
    bar
  end
  around :complex_with_methods_and_blocks_foo do |&block|
    bar
    block.call
    bar
  end

  before(/^regex_block_before.+$/) do
    bar
  end

  before(/^regex_block_method_before.+$/) do
    bar
  end
  after(/^regex_block_method_before.+$/ => :bar)

  around [:array_around_method1_foo, :array_around_method2_foo] => :around_bar

  before %w{array_block_before_method1_foo array_block_before_method2_foo} do
    bar
  end

  before %w{array_block_method_before_method1_foo array_block_method_before_method2_foo} do
    bar
  end
  after %w{array_block_method_before_method1_foo array_block_method_before_method2_foo} => :bar


  def initialize
    @result = []
    callback_binding
  end

  %w{
  before after
  around
  multiple_before
  multiple_after
  multiple_around
  complex
  block_before
  block_after
  block_around
  complex_with_blocks
  complex_with_methods_and_blocks
  regex_before_method1
  regex_before_method2
  regex_block_before_method1
  regex_block_before_method2
  regex_block_method_before_method1
  regex_block_method_before_method2
  array_around_method1
  array_around_method2
  array_block_before_method1
  array_block_before_method2
  array_block_method_before_method1
  array_block_method_before_method2
  }.each do |prefix|
    define_method "#{prefix}_foo" do
      foo
    end
  end

  private
  def foo
    @result << 'foo'
  end

  def bar
    @result << 'bar'
  end

  def around_bar
    bar
    yield
    bar
  end
end
