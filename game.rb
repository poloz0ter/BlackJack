require_relative 'card'
require_relative 'deck'
require_relative 'person'
require_relative 'interface'
require_relative 'dealer'
require_relative 'player'

class Game
  def initialize
    @interface = Interface.new
    @player = Player.new
    @dealer = Dealer.new
    @interface.ask_name
    @player.name = gets.chomp.strip
    validate_name
  rescue StandardError => e
    puts e.message
    retry
  end

  def start
    @deck = Deck.new
    @player.hand.cards = []
    @dealer.hand.cards = []
  end

  def distribution
    2.times do
      @player.take_card(@deck.give_a_card)
      @dealer.take_card(@deck.give_a_card)
    end
    @dealer.hand.points
    @player.hand.points
  end

  def bet
    @player.money -= 10
    @dealer.money -= 10
    @interface.show_desk(@player.show_name, @player.hand.show_cards, @player.hand.score, @player.show_money)
    @interface.show_desk('Dealer', '***', '***', @dealer.show_money)
  end

  def player_action
    begin
      @interface.action
    rescue StandardError => e
      puts e.message
      retry
    end
    @player.take_card(@deck.give_a_card) if @interface.input == 1
    @player.hand.points
    dealer_action
  end

  def dealer_action
    if @dealer.hand.score >= 17 || @interface.input == 2
      nil
    else
      @dealer.take_card(@deck.give_a_card)
      @dealer.hand.points
    end
  end

  def result
    draw if @player.hand.score > 21 && @dealer.hand.score > 21
    draw if @player.hand.score == @dealer.hand.score
    win if @player.hand.score > @dealer.hand.score && @player.hand.score <= 21
    win if @dealer.hand.score > 21 && @player.hand.score <= 21
    lose if @player.hand.score > 21 && @dealer.hand.score <= 21
    lose if @dealer.hand.score > @player.hand.score && @dealer.hand.score <= 21
    desk
  end

  def desk
    @interface.show_desk(@player.show_name, @player.hand.show_cards, @player.hand.score, @player.show_money)
    @interface.show_desk(@dealer.name, @dealer.hand.show_cards, @dealer.hand.score, @dealer.show_money)
  end

  def end_game
    @interface.no_money(@player.show_name) if @player.money <= 0
    @interface.no_money(@dealer.name) if @dealer.money <= 0
    @interface.exit_game
  rescue StandardError => e
    puts e.message
    retry
  end

  def lose
    @dealer.money += 20
    @interface.lose
  end

  def win
    @player.money += 20
    @interface.win
  end

  def draw
    @dealer.money += 10
    @player.money += 10
    @interface.draw
  end
  
  private
  
  def validate_name
  raise 'Wrong name' if @player.name.nil? || @player.name.strip.empty?
  end
end

game = Game.new
loop do
  game.start
  game.distribution
  game.bet
  game.player_action
  game.result
  game.end_game
end
