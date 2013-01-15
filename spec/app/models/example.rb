class Example
  include Callmeback

  before :before_foo => :bar
  after :after_foo => :bar
  around :around_foo => :around_bar

  before :multiple_before_foo => [:bar, :bar]
  after :multiple_after_foo => [:bar, :bar]
  around :multiple_around_foo => [:around_bar, :around_bar]

  before :complex_foo => :bar
  around :complex_foo => [:around_bar, :around_bar]
  after :complex_foo => [:bar, :bar]

  def initialize
    @result = []
    callback_binding
  end

  %w{before after around multiple_before multiple_after multiple_around complex}.each do |prefix|
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
