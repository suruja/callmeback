require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Callmeback do

  let(:example) do
    Example.new
  end

  it "should have created 3 methods: before, after, around" do
    [:before, :after, :around].each do |method_name|
      expect{ Example.method method_name }.to_not raise_error(NameError)
    end
  end

  describe ".before" do
    it "should fire a callback before the original method is executed" do
      example.before_foo.should == %w{bar foo}
    end
  end

  describe ".after" do
    it "should fire a callback after the original method is executed" do
      example.after_foo.should == %w{foo bar}
    end
  end

  describe ".around" do
    it "should fire a callback around the original method is executed" do
      example.around_foo.should == %w{bar foo bar}
    end
  end
end
