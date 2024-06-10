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

  it 'is not listening on a port before it is started' do
    @server.stop
    expect { Client.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
  end

  describe '#accept_new_client' do
    it 'adds new client to pending_clients array' do
      make_client
      expect(@server.pending_clients.count).to eq 1
    end
  end

  describe '#create_player' do
    it 'associates the client with a Player' do
      make_client
      allow(@server).to receive(:name?).and_return('Player 1')
      @server.create_player
      expect(@server.pending_clients[@server.pending_clients.keys.last].name).to eq 'Player 1'
    end
  end

  describe '#create_game_if_possible' do
    it '' do
    end
  end

  def make_client
    client = Client.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
  end
end
