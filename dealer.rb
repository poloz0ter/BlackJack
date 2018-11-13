require_relative 'person'

class Dealer < Person
  def initialize
    @name = 'Dealer'
    super
  end
end
