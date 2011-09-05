require './method-filter.rb'

class Client < Filter::Methods
  def initialize
    after_before_filter([:bye, :cya], [:hey, :hello], [:hey, :hello])
  end
  
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

cli = Client.new

cli.cya
cli.bye