# frozen_string_literal: true

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_accessor :game, :clients, :server

  def initialize(game, clients, server)
    @game = game
    @clients = clients
    @server = server
  end

  def run
    game.start
    game_loop until game.winner
    message_players("#{game.winner.name} wins the game!")
    clients.each(&:close)
  end

  def game_loop
    display_hand
    choice = rank_choice
    # input2 = self.player, who do you want to ask for that card?
    # play_round(get 2, from jullian)
    #   Does jullian have it? If Yes -> move 2 from jullian to gabriel and do not update player
    #                         If No -> Player draws from the pond and update player
    game.winner = game.players[0]
  end

  def rank_choice
    input = ''
    message = "#{game.current_player.name}, choose a rank to ask for: "
    client = find_client_for_player(game.current_player)
    client.puts(message)
    input = server.capture_client_input(client) until game.validate_rank(input)
    input
  end

  def display_hand
    name = game.current_player.name
    hand = game.current_player.hand
    hand_string = hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
    message = "#{name}'s hand: #{hand_string}\n"

    client = find_client_for_player(game.current_player)
    client.puts(message)
  end

  def find_client_for_player(player)
    index = game.players.index(player)
    @clients[index]
  end
end
