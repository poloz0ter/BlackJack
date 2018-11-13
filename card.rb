class Card
  SUITS = ['♠', '♥', '♣', '♦'].freeze
  VALUES = [2, 3, 4, 5, 6, 7, 8, 10, 'J', 'Q', 'K', 'A'].freeze

  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def ace?
    value == 'A'
  end

  def points
    return value if value.is_a?(Integer)
    return 10 if ["J", "Q", "K"].include?(value)
    return 11 if value == 'A'
  end
end
