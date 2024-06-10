# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game_runner'

RSpec.describe GameRunner do
  let(:card1) { Card.new('3', 'H') }
  let(:card2) { Card.new('4', 'C') }
  let(:player1) { Player.new(name: 'Player 1') }
  let(:player2) { Player.new(name: 'Player 2') }

  before do
    @game = Game.new([player1, player2])
    @game_runner = GameRunner.new(@game)
  end

  before do
    @game.players[0].hand = [card1, card2]
  end

  describe '#display_hand' do
    it "displays first player's hand" do
      expect { @game_runner.display_hand }.to output("Player 1's hand: 3H, 4C\n").to_stdout
    end
  end

  describe '#rank_choice' do
    it 'asks player for a choice until choice is valid' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('1', '3')
      expect(@game_runner).to receive(:puts).with('Player 1, choose a rank to ask for: ').twice
      expect(@game_runner.rank_choice).to eq('3')
    end
  end
end
