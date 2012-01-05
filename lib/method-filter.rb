#TODO 
# Create a Without method when the before filter is called to allow old behavior 
# add the removal of filters

class Object
  private
  def create_method_filter(original, before, after)
    old_method = self.class.instance_method(original)
    self.class.send(:define_method, original) do |*args|
      self.send before, *args[old_method.arity..args.length-1] unless before.nil?
      old_method.bind(self).call *args[0..old_method.arity-1]
      self.send after, *args[old_method.arity..args.length-1] unless after.nil?
    end
  end

  def method_missing(method, *args)
    if ['before_filter', 'after_filter'].include?(method.to_s)
      if args.length == 2
        original_method = args[0]
        added_method = args[1]
        case method.to_s
        when 'before_filter'
          create_method_filter(original_method, added_method, nil)
        when 'after_filter'
          create_method_filter(original_method, nil, added_method)
        end
      else
        raise(ArgumentError,'Incorrect number of arguments!')
      end
    else
      super
    end
  end
end
