class Example
  include ActiveSupport::Callbacks
  include Callmeback

  before :before_foo => :bar
  after :after_foo => :bar
  around :around_foo => :around_bar

  def initialize
    @result = []
    callback_binding
  end

  def before_foo; foo; end
  def after_foo; foo; end
  def around_foo; foo; end

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
