require './method-filter.rb'

class Client < Filter::Methods
  def initialize
    after_before_filter([:bye => 'bye'], [:hey, :hello => ['he', 'llo']], [:hey, :hello])
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
end

cli = Client.new

cli.cya
cli.bye