# frozen_string_literal: false

require 'spec_helper'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/client'
require_relative '../lib/game_runner'

RSpec.describe GameRunner do
  let(:cards) { [Card.new('3', 'H'), Card.new('4', 'C'), Card.new('3', 'D'), Card.new('3', 'C'), Card.new('3', 'S')] }
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

  def capture_kernel
    clients.map do |client|
      output = ''
      allow(client).to receive(:puts) do |message|
        output << message
      end
      output
    end
  end

  before do
    game.players[0].hand = cards[0..1]
    game.players[1].hand = cards[2..4]
  end

  describe '#display_hand' do
    it "sends first player's hand to the client" do
      captured_output = capture_kernel

      runner.display_hand
      expect(captured_output.first).to eq "Player 1's hand: 3H, 4C\n"
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
      allow(@server).to receive(:capture_client_input).and_return('3', '2')
      expect(runner.opponent_choice).to eq(runner.game.players[1])
    end
  end

  describe '#display_game_update' do
    it "sends a message to the current player's client with the game update" do
      allow(game).to receive(:last_turn_opponent).and_return(game.players[1])
      allow(game).to receive(:last_turn_card_taken).and_return('3')
      allow(game).to receive(:last_turn_books).and_return(['3'])

      captured_outputs = capture_kernel

      runner.display_game_update

      expected_messages = [
        "You took 3's from your opponent.\nYou made books with: 3\n",
        "Your 3's were taken by Player 1.\n"
      ]

      expect(captured_outputs).to eq(expected_messages)
    end
  end
end
