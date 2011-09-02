class Object
  private
  def filter(original, before, after)
    #ensure that the arguments are arrays because a single symbol can be given
    original = [original] if (original.class != Array and !original.nil?)
    before = [before] if (before.class != Array and !before.nil?)
    after = [after] if (after.class != Array and !after.nil?)
    #for each original method append the before/after methods
    original.each do |orig|
      #save the old method before it is overwritten
      old_method = self.class.instance_method(orig)
      #create the new method calling all the filters
      buff = create_method(orig){
        #call before filters
        before.each { |bef| self.send bef } unless before.nil?
        #call original method
        old_method.bind(self).call
        #call after filters
        after.each { |bef| self.send bef } unless after.nil?
      }
    end
  end

  #override the old method with the new block
  def create_method(name, &block)
    self.class.send(:define_method, name, &block)
  end
  
  #method missing that will dispatch to the filter method properly
  def method_missing(method, *args)
    parsed_method = method.to_s.split('_')
    if (parsed_method - ['before','after','filter']).length == 0 and parsed_method.length <= 3
      if args.length < 3 or args.length != parsed_method.length
        #raise an error because filter was called with the wrong number of arguments
        raise 'Too many or too few arguments!'
      else
        #split arguments and map them to their before/after filter
        arg_arr = {}
        parsed_method.each_with_index do |filter, i|
          arg_arr[filter] = args[i+1]
        end
        #call the filter method using the prepared data
        filter(args[0], arg_arr['before'], arg_arr['after'])
      end
    else
      #call super::missing method because the method called is not a filter
      super
    end
  end
end