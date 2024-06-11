# frozen_string_literal: false

require 'spec_helper'
require 'socket'
require_relative '../lib/server'
require_relative '../lib/client'
require_relative '../lib/game_runner'

RSpec.describe GameRunner do
  let(:cards) { [Card.new('3', 'H'), Card.new('4', 'C'), Card.new('3', 'D'), Card.new('3', 'C'), Card.new('3', 'S')] }
  let(:game) { @server.create_game_if_possible }
  let(:client1) { make_client('Player 1') }
  let(:client2) { make_client('Player 2') }
  let(:runner) { @server.create_runner(game) }

  before(:each) do
    @clients = []
    @server = Server.new
    @server.start
    sleep 0.1
    client1
    client2
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  def make_client(name)
    client = Client.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client
    client.provide_input(name)
    @server.create_player_if_possible
    client
  end

  before do
    client1.capture_output
    game.players[0].hand = cards[0..1]
    game.players[1].hand = cards[2..4]
  end

  describe '#display_hand' do
    it "sends first player's hand to the client" do
      runner.display_hand
      expect(client1.capture_output).to eq "Player 1's hand: 3H, 4C\n"
    end
  end

  describe '#get_choice' do
    it 'returns rank if rank choice is valid' do
      client1.provide_input('3')
      result = runner.get_choice(:validate_rank, runner.rank_prompt)
      expect(result).to eq('3')
    end

    it 'returns invalid input message if rank choice is invalid' do
      client1.capture_output
      client1.provide_input('6')
      runner.validation_loop(runner.clients[0], :validate_rank)
      expect(client1.capture_output).to include("Invalid input. Please try again: \n")
    end

    it 'returns opponent if opponent choice is valid ' do
      client1.provide_input('2')
      result = runner.get_choice(:validate_opponent, runner.opponent_prompt)
      expect(result).to eq(runner.game.players[1])
    end

    it 'returns invalid input message if opponent choice is invalid' do
      client1.capture_output
      client1.provide_input('3')
      runner.validation_loop(runner.clients[0], :validate_opponent)
      expect(client1.capture_output).to include("Invalid input. Please try again: \n")
    end
  end

  describe '#display_game_update' do
    xit "sends a message to the current player's client with the game update" do
      game.last_turn_opponent = game.players[1]
      game.last_turn_card_taken = '3'
      game.last_turn_books = ['3']

      runner.display_game_update

      expected_messages = [
        "You took 3's from your opponent.\nYou made books with: 3\n",
        "Your 3's were taken by Player 1.\n"
      ]

      expect(captured_outputs).to eq(expected_messages)
    end
  end
end
