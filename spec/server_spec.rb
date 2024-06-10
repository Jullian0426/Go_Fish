# frozen_string_literal: true

require 'spec_helper'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/client'
require_relative '../lib/game_runner'

RSpec.describe Server do
  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  def make_client
    client = Client.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    client
  end

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  describe '#accept_new_client' do
    it 'adds new client to unnamed_clients array' do
      make_client
      expect(@server.unnamed_clients.count).to eq 1
    end
  end

  describe '#create_player_if_possible' do
    it 'associates the client with a Player' do
      client = make_client
      client.provide_input('Player 1')
      @server.create_player_if_possible
      expect(@server.pending_clients[@server.pending_clients.keys.last].name).to eq 'Player 1'
    end
  end

  describe '#create_game_if_possible' do
    it 'should send waiting message if there are not enough players' do
      client1 = make_client
      client1.provide_input('Player 1')
      @server.create_player_if_possible
      client1.capture_output
      @server.create_game_if_possible
      expect(client1.capture_output.chomp).to eq 'Waiting for more players...'
    end

    it 'should create a game when there are enough players' do
      2.times do |i|
        client = make_client
        client.provide_input("Player #{i + 1}")
        @server.create_player_if_possible
      end
      @server.create_game_if_possible
      expect(@server.games.count).to eq 1
    end
  end

  describe '#name' do
    it 'should prompt the user to input a name' do
      socket = make_client
      client = @server.unnamed_clients.last
      socket.provide_input('Player 1')
      name = @server.name(client)

      expect(name).to eq 'Player 1'
    end
  end
end
