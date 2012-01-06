#TODO 
#need to change the before/after to only accept instance variables
# Create a Without method when the before filter is called to allow old behavior 
# add the removal of filters

class Object
  private
  def create_method_filter(original, before, after)
    old_method = self.class.instance_method(original)
    if self.class.instance_method(before).arity > 0 or self.class.instance_method(after).arity > 0
      raise ArgumentError, 'Before/After filters do not support methods that require arguments'
    end
    self.class.send(:define_method, original) do |*args|
      self.send before unless before.nil?
      old_method.bind(self).call *args
      self.send after unless after.nil?
    end
  end

  def method_missing(method, *args)
    if ['before_filter', 'after_filter'].include?(method.to_s)
      if args.length == 2
        original_method = args[0]
        added_method = args[1]
        if method.to_s == 'before_filter'
          create_method_filter(original_method, added_method, nil)
        else
          create_method_filter(original_method, nil, added_method)
        end
      else
        raise ArgumentError,'Incorrect number of arguments!'
      end
    else
      super
    end
  end
end
