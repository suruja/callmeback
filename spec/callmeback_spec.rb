require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Callmeback do

  %w{Example ExampleActiveRecord ExampleMongoid}.each do |klass|
    context "using #{klass}" do
      let(:example) do
        klass.constantize.new
      end

      it "should have created 3 methods: before, after, around" do
        [:before, :after, :around].each do |method_name|
          expect{ klass.constantize.method method_name }.to_not raise_error(NameError)
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

      context "the gem should handle regex as callback argument" do
        it "should fire the callback for all the given methods that match the given regex" do
          example.regex_before_method1_foo.should == %w{bar foo}
          example.result.clear
          example.regex_before_method2_foo.should == %w{bar foo}
        end

        it "should fire the callback for all the given blocks that match the given regex" do
          example.regex_block_before_method1_foo.should == %w{bar foo}
          example.result.clear
          example.regex_block_before_method2_foo.should == %w{bar foo}
        end

        it "should fire the callback for all the given methods and blocks that match the given regex" do
          example.regex_block_method_before_method1_foo.should == %w{bar foo bar}
          example.result.clear
          example.regex_block_method_before_method2_foo.should == %w{bar foo bar}
        end
      end

      context "the gem should handle array as callback argument" do
        it "should fire the callback for all the given methods that are included in the given array" do
          example.array_around_method1_foo.should == %w{bar foo bar}
          example.result.clear
          example.array_around_method2_foo.should == %w{bar foo bar}
        end

        it "should fire the callback for all the given blocks that are included in the given array" do
          example.array_block_before_method1_foo.should == %w{bar foo}
          example.result.clear
          example.array_block_before_method2_foo.should == %w{bar foo}
        end

        it "should fire the callback for all the given methods and blocks that are included in the given array" do
          example.array_block_method_before_method1_foo.should == %w{bar foo bar}
          example.result.clear
          example.array_block_method_before_method2_foo.should == %w{bar foo bar}
        end
      end
    end
  end
end
