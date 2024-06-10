# frozen_string_literal: true

require 'socket'
require_relative 'game'
require_relative 'player'
require_relative 'game_runner'

# The Server class represents a socket server for the Go Fish card game.
class Server
  attr_accessor :pending_clients

  def initialize
    @users = {}
    @pending_clients = {}
    @client_messages_sent = {}
    @accept_message = false
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
  rescue IO::WaitReadable, Errno::EINTR
    accept_message_handler
  end

  def create_player
    client = pending_clients.keys.last
    name = name?(client)
    player = Player.new(name: name)
    pending_clients[client] = player
  end

  def create_game_if_possible

  end

  def name?(client)
    
  end

  def accept_message_handler
    if accept_message == false
      puts 'No client to accept'
      self.accept_message = true
    else
      puts 'Accepted client'
      self.accept_message = false
    end
  end
end
