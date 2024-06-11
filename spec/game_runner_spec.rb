# frozen_string_literal: false

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
      captured_output = ''

      allow_any_instance_of(Kernel).to receive(:puts) do |_, message|
        captured_output << message
      end

      runner.display_hand
      expect(captured_output).to eq "Player 1's hand: 3H, 4C\n"
    end
  end

  before do
    allow_any_instance_of(Kernel).to receive(:puts)
  end

  describe '#rank_choice' do
    it 'returns choice if rank is valid' do
      allow(@server).to receive(:capture_client_input).and_return('1', '3')
      expect(runner.rank_choice).to eq('3')
    end
  end

  describe '#opponent_choice' do
    it 'returns choice if opponent is valid ' do
      allow_any_instance_of(Kernel).to receive(:puts)
      allow(@server).to receive(:capture_client_input).and_return('3', '2')
      expect(runner.opponent_choice).to eq(runner.game.players[1])
    end
  end
end
