# frozen_string_literal: true

# The GameRunner class is responsible for running the game of Go Fish.
class GameRunner
  attr_accessor :game, :clients

  def initialize(game, clients)
    @game = game
    @clients = clients
  end

  def run
    game.start
    game_loop until game.winner
    clients.each { |client| client.puts("#{game.winner.name} wins the game!") }
    clients.each(&:close)
  end

  def game_loop
    display_hand
    rank = get_choice(:validate_rank, rank_prompt)
    opponent = get_choice(:validate_opponent, opponent_prompt)
    game.play_round(rank, opponent)
    display_game_update
  end

  def display_hand
    name = game.current_player.name
    hand = game.current_player.hand
    hand_string = hand.map { |card| "#{card.rank}#{card.suit}" }.join(', ')
    message = "#{name}'s hand: #{hand_string}\n"

    client = find_client_for_player(game.current_player)
    client.puts(message)
  end

  def get_choice(validation_method, prompt)
    client = find_client_for_player(game.current_player)
    client.puts(prompt)
    result = validation_loop(client, validation_method) until result
    result
  end

  def validation_loop(client, validation_method)
    input = capture_client_input(client)
    unless input.empty?
      choice_var = game.send(validation_method, input)
      invalid_input_message(client) unless choice_var
    end
    choice_var
  end

  def rank_prompt
    "#{game.current_player.name}, choose a rank to ask for: "
  end

  def opponent_prompt
    player_list = game.players.map(&:name).join(', ')
    "#{player_list}
    #{game.current_player.name}, choose an opponent to take from by typing a number
    (ex: 1 for first player listed): "
  end

  def display_game_update
    game.players.each do |player|
      client = find_client_for_player(player)
      client.puts(game.game_update_message(player))
    end
  end

  def find_client_for_player(player)
    index = game.players.index(player)
    @clients[index]
  end

  def capture_client_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp.upcase
  rescue IO::WaitReadable
    @output = ''
  end

  def invalid_input_message(client)
    client.puts('Invalid input. Please try again: ')
  end
end
