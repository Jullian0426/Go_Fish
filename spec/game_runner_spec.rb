# frozen_string_literal: true

require 'spec_helper'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/client'
require_relative '../lib/game_runner'

RSpec.describe GameRunner do
  let(:cards) { [Card.new('3', 'H'), Card.new('4', 'C')] }
  let(:players) { Array.new(2) { |i| Player.new(name: "Player #{i + 1}") } }
  let(:game) { Game.new(players) }
  let(:clients) { Array.new(2) { Client.new(@server.port_number) } }
  let(:runner) { GameRunner.new(game, clients, @server) }

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

  before do
    game.players[0].hand = cards
  end

  describe '#display_hand' do
    it "sends first player's hand to the client" do
      runner.display_hand
      expect(clients[0].capture_output).to eq "Player 1's hand: 3H, 4C\n"
    end
  end

  describe '#rank_choice' do
    it 'asks player for a choice until choice is valid' do
      expect(runner.rank_choice).to eq('3')
    end
  end
end
