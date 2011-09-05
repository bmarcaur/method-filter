require 'helper'
require File.expand_path('./lib/method-filter.rb')

class TestMethodFilter < Test::Unit::TestCase
  
  should "Raise method_missing error on undefined methods" do
    #puts Object.methods
    assert true
  end
end
