# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'

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
end
