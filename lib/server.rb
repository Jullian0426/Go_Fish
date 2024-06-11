# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'
require_relative 'game_runner'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :pending_clients, :clients_waiting, :games, :users, :accept_message, :prompted_name, :unnamed_clients

  def initialize
    @users = {}
    @pending_clients = {}
    @unnamed_clients = []
    @clients_waiting = {}
    @prompted_name = {}
    @accept_message = false
    @games = []
  end

  def port_number
    3336
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server&.close
  end

  def accept_new_client
    client = @server.accept_nonblock
    unnamed_clients << client
    puts 'Accepted client'
  rescue IO::WaitReadable, Errno::EINTR
    accept_message_handler
  end

  def create_player_if_possible
    unnamed_clients.each do |client|
      name = name(client)
      next unless name != ''

      create_player(client, name)
    end
  end

  def create_player(client, name)
    player = Player.new(name: name)
    unnamed_clients.delete(client)
    pending_clients[client] = player
    users[client] = player
  end

  # TODO: rename
  def name(client)
    if prompted_name[client].nil?
      client.puts('Please enter your name:')
      prompted_name[client] = true
    end
    capture_client_input(client)
  end

  def create_game_if_possible
    if pending_clients.size >= Game::MIN_PLAYERS
      create_game
    elsif pending_clients.size < Game::MIN_PLAYERS && !pending_clients.empty?
      waiting_handler
    end
  end

  def run_game(game)
    create_runner(game)
    runner.run
  end

  def create_runner(game)
    clients = game.players.map { |player| users.key(player) }
    GameRunner.new(game, clients)
  end

  def accept_message_handler
    return unless accept_message == false

    puts 'No client to accept'
    self.accept_message = true
  end

  def create_game
    games << Game.new(pending_clients.values)
    pending_clients.clear
    games.last
  end

  def capture_client_input(client)
    sleep(0.1)
    client.read_nonblock(1000).chomp
  rescue IO::WaitReadable
    @output = ''
  end

  def waiting_handler
    client = pending_clients.keys.first
    unless clients_waiting[client]
      client.puts('Waiting for more players...')
      clients_waiting[client] = true
    end
    nil
  end
end
