require_relative 'hand'

class Person
  attr_accessor :money
  attr_reader :hand, :name

  def initialize
    @hand = Hand.new
    @money = 100
  end

  def take_card(card)
    @hand.cards << card
  end

  def show_money
    money.to_s
  end
end
