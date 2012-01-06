require './method-filter.rb'

class Client
  def initialize
    @testvar = 'BYE'
    before_filter(:hello, :bye)
    #after_filter(:bye => ['bye'], :hey)
  end

  def hello(str, str2)
    puts str + str2
  end

  def bye(str)
    puts str
  end

  def hey
    puts 'hey'
  end

  def cya
    puts 'cya'
  end

  def change_var
    @testvar = 'bye'
  end
end

cli = Client.new
cli.change_var

cli.hello 'he', 'llo'
