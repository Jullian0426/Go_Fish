# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'
require_relative '../lib/card'

RSpec.describe Game do
  let(:player2) { Player.new(name: 'Player 2') }
  let(:player1) { Player.new(name: 'Player 1') }
  let(:game) { Game.new([player1, player2]) }

  describe '#initialize' do
    it 'responds to players' do
      expect(game).to respond_to :players
    end
  end

  describe '#start' do
    it 'should tell deck to shuffle' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end

    it 'deal players 5 cards' do
      game.start
      p1_hand_size = game.players.first.hand.size
      p2_hand_size = game.players.last.hand.size
      expect(p1_hand_size).to eq 5
      expect(p2_hand_size).to eq 5
      deck_size = game.deck.cards.size
      expect(deck_size).to eq 42
    end
  end

  describe '#validate_rank?' do
    let(:card1) { Card.new('3', 'H') }
    let(:card2) { Card.new('4', 'C') }

    before do
      game.players.first.hand = [card1, card2]
    end

    it "returns true if rank is present in current player's hand" do
      expect(game.validate_rank?('3')).to be true
    end

    it "returns false if rank is not present in current player's hand" do
      expect(game.validate_rank?('6')).to be false
    end
  end

  describe '#validate_opponent' do
    it 'returns selected player if player exists' do
      result = game.validate_opponent('1')
      expect(result).to eq player1
    end

    it 'returns nil if selected player does not exist' do
      result = game.validate_opponent('3')
      expect(result).to eq nil
    end
  end
end
