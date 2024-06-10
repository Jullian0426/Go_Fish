# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'
require_relative 'game_runner'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :pending_clients, :clients_waiting, :games, :users, :accept_message

  def initialize
    @users = {}
    @pending_clients = {}
    @clients_waiting = {}
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
    pending_clients[client] = nil
    puts 'Accepted client'
  rescue IO::WaitReadable, Errno::EINTR
    accept_message_handler
  end

  def create_player_if_possible
    return if pending_clients.empty?

    client = pending_clients.keys.last
    return unless pending_clients[client].nil?

    name = name?(client)
    return unless name != ''

    create_player(client, name)
  end

  def create_player(client, name)
    player = Player.new(name: name)
    pending_clients[client] = player
    users[client] = player
  end

  def name?(client)
    client.puts('Please enter your name:')
    client.gets.chomp
  end

  def create_game_if_possible
    # TODO: change to MIN_PLAYERS variable
    if pending_clients.size >= 2
      create_game
    elsif pending_clients.size == 1
      waiting_handler
    end
  end

  def run_game(game)
    clients = game.players.map { |player| users.key(player) }
    runner = GameRunner.new(game, clients)
    runner.run
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

  def waiting_handler
    client = pending_clients.keys.first
    unless clients_waiting[client]
      client.puts('Waiting for more players...')
      clients_waiting[client] = true
    end
    nil
  end
end
