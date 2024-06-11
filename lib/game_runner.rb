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
    clients.each { |client| client.puts("#{game.winner.name} wins the game!") }
    clients.each(&:close)
  end

  def game_loop
    # display_hand
    # rank = rank_choice
    # opponent = opponent_choice
    # game.play_round(rank, opponent)
  end

  def display_hand
    name = game.current_player.name
    hand = game.current_player.hand
    hand_string = hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
    message = "#{name}'s hand: #{hand_string}\n"

    client = find_client_for_player(game.current_player)
    client.puts(message)
  end

  def rank_choice
    client = find_client_for_player(game.current_player)
    client.puts("#{game.current_player.name}, choose a rank to ask for: ")
    validate_rank_loop(client)
  end

  def validate_rank_loop(client)
    rank = nil
    until rank
      input = server.capture_client_input(client)
      rank = input if game.validate_rank?(input)
      invalid_input_message(client) unless rank
    end
    rank
  end

  def opponent_choice
    client = find_client_for_player(game.current_player)
    client.puts(opponent_prompt)
    validate_opponent_loop(client)
  end

  def opponent_prompt
    player_list = game.players.map(&:name).join(', ')
    "#{player_list}
    #{game.current_player.name}, choose an opponent to take from by typing a number
    (ex: 1 for first player listed): "
  end

  def validate_opponent_loop(client)
    opponent = nil
    until opponent
      input = server.capture_client_input(client)
      opponent = game.validate_opponent(input)
      invalid_input_message(client) unless opponent
    end
    opponent
  end

  def find_client_for_player(player)
    index = game.players.index(player)
    @clients[index]
  end

  def invalid_input_message(client)
    client.puts('Invalid input. Please try again: ')
  end
end
