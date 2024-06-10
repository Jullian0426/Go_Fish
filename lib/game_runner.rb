# frozen_string_literal: true

require_relative 'game'
require_relative 'player'

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_reader :game

  def initialize
    @game = create_game
  end

  def create_game
    puts('Provide name for first player:')
    p1_name = gets.chomp
    puts('Provide name for second player:')
    p2_name = gets.chomp
    player1 = Player.new(name: p1_name)
    player2 = Player.new(name: p2_name)
    Game.new([player1, player2])
  end

  def game_loop
    game.start
    until game.winner
      display_hand
      choice = rank_choice
      # input2 = self.player, who do you want to ask for that card?
      # play_round(get 2, from jullian)
      #   Does jullian have it? If Yes -> move 2 from jullian to gabriel and do not update player
      #                         If No -> Player draws from the pond and update player
      game.winner = game.players[0]
    end
  end

  def rank_choice
    input = nil
    until game.validate_rank(input)
      puts("#{game.current_player.name}, choose a rank to ask for: ")
      input = gets.chomp
    end
    input
  end

  def display_hand
    name = game.players[0].name
    hand = game.players[0].hand
    hand_string = hand.map { |card| "#{card.rank}#{card.suit}" }.join(", ")
    puts("#{name}'s hand: #{hand_string}\n")
  end
end
