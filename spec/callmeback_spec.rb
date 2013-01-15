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

  context "the callback value is an array of methods" do
    describe ".before" do
      it "should fire array-length callbacks before the original method is executed" do
        example.multiple_before_foo.should == %w{bar bar foo}
      end
    end

    describe ".after" do
      it "should fire array-length callbacks after the original method is executed" do
        example.multiple_after_foo.should == %w{foo bar bar}
      end
    end

    describe ".around" do
      it "should fire array-length callbacks around the original method is executed" do
        example.multiple_around_foo.should == %w{bar bar foo bar bar}
      end
    end
  end

  context "the gem should handle complex callback structures" do
    it "should fire the callbacks in the order of their call" do
      example.complex_foo.should == %w{bar bar bar foo bar bar bar bar}
    end
  end

  context "the gem should handle blocks as callbacks" do
    it "should fire a callback block before the original method is executed" do
      example.block_before_foo.should == %w{bar foo}
    end

    it "should fire a callback block after the original method is executed" do
      example.block_after_foo.should == %w{foo bar}
    end

    it "should fire a callback block around the original method is executed" do
      example.block_around_foo.should == %w{bar foo bar}
    end
  end

  context "the gem should handle blocks as callbacks" do
    it "should fire the callbacks in the order of their call" do
      example.complex_with_blocks_foo.should == %w{bar bar bar foo bar bar}
    end
  end

  context "the gem should handle blocks as callbacks and methods" do
    it "should fire the callbacks in the order of their call" do
      example.complex_with_methods_and_blocks_foo.should == %w{bar bar bar foo bar bar}
    end
  end
end
