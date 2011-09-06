require 'helper'

describe "Improper Method Calling" do
  before :each do
    class Client < Filter::Methods      
      def hello
        puts 'hello'
      end

      def bye
        puts 'bye'
      end

      def hey
        puts 'hey'
      end

      def cya
        puts 'cya'
      end
    end
    @client = Client.new
  end
  
  it "raises a no method error when the method does not exist and it is not a filter" do
    lambda { @client.not_a_method.should_raise() }.should raise_error(NoMethodError)
  end
  
  it "raises an argument error when a before/after filter is called with too many arguments" do
    lambda { @client.send(:before_filter, :hello, :hey, :bye, :cya) }.should raise_error(ArgumentError, 'Too many arguments!')
    lambda { @client.send(:after_filter, :hello, :hey, :bye, :cya) }.should raise_error(ArgumentError, 'Too many arguments!')
    lambda { @client.send(:before_after_filter, :hello, :hey, :bye, :cya) }.should raise_error(ArgumentError, 'Too many arguments!')
    lambda { @client.send(:after_before_filter, :hello, :hey, :bye, :cya) }.should raise_error(ArgumentError, 'Too many arguments!')
  end

  it "raises an argument error when a before/after filter is called with too few arguments" do
    lambda { @client.send(:before_filter) }.should raise_error(ArgumentError, 'Too few arguments!')
    lambda { @client.send(:after_filter) }.should raise_error(ArgumentError, 'Too few arguments!')
    lambda { @client.send(:before_after_filter) }.should raise_error(ArgumentError, 'Too few arguments!')
    lambda { @client.send(:after_before_filter) }.should raise_error(ArgumentError, 'Too few arguments!')
  end
  
  it "raises an invalid argument error when a before/after filter is called with incorrect argument types" do
    lambda { @client.send(:after_filter, 'hello', :hello) }.should raise_error(ArgumentError, 'One of the arguments is not a symbol or array!')
    lambda { @client.send(:before_after_filter, 'hello', :hello, :hey) }.should raise_error(ArgumentError, 'One of the arguments is not a symbol or array!')
    lambda { @client.send(:after_filter, ['hello', :hello], :hello) }.should raise_error(ArgumentError, 'One of the arrays contained a type other than a Symbol!')
    lambda { @client.send(:before_after_filter, :hello, [:hello, 'hello'], :hey) }.should raise_error(ArgumentError, 'One of the arrays contained a type other than a Symbol!')
  end
  
  describe "Calling a filter properly" do
    before :each do
      class Client < Filter::Methods
        def initialize
          @arr = Array.new
        end

        def get
          @arr
        end
        
        def get_without
          @arr
        end

        def add
          @arr << 1
        end
      end
      @client = Client.new
    end
    it "with a single before filter causes the before method to be called before the original method" do
      puts @client.get
      @client.send(:before, :get, :add)
      @client.get.length.should == 1
    end
  end
end
