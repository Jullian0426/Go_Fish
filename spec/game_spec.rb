# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'
require_relative '../lib/card'

RSpec.describe Game do
  let(:player1) { Player.new(name: 'Player 1') }
  let(:player2) { Player.new(name: 'Player 2') }
  let(:game) { Game.new([player1, player2]) }

  describe '#initialize' do
    it 'responds to players' do
      expect(game).to respond_to :players
    end
  end

  xit 'runs a game from start to finish' do
    game.start
    until game.winner
      rank = game.current_player.hand.sample.rank
      opponent = game.players.find { |player| player != game.current_player }
      game.play_round(rank, opponent)
    end
    expect(game.winner).not_to be_nil
  end

  describe '#start' do
    it 'should tell deck to shuffle' do
      expect(game.deck).to receive(:shuffle).once
      game.start
    end

    before do
      game.start
    end

    let(:original_deck_size) { game.deck.cards.size }
    let(:p1_hand_size) { game.players.first.hand.size }
    let(:p2_hand_size) { game.players.last.hand.size }

    it 'deal players cards according to STARTING_HAND variable' do
      expect(p1_hand_size).to eq Game::STARTING_HAND
      expect(p2_hand_size).to eq Game::STARTING_HAND
      deck_size = game.deck.cards.size
      expect(deck_size).to eq original_deck_size
    end
  end

  describe '#validate_rank' do
    let(:card1) { Card.new('3', 'H') }
    let(:card2) { Card.new('4', 'C') }

    before do
      game.players.first.hand = [card1, card2]
    end

    it "returns true if rank is present in current player's hand" do
      expect(game.validate_rank('3')).to eq '3'
    end

    it "returns false if rank is not present in current player's hand" do
      expect(game.validate_rank('6')).to eq nil
    end
  end

  describe '#validate_opponent' do
    it 'returns selected player if player exists' do
      result = game.validate_opponent('2')
      expect(result).to eq player2
    end

    it 'returns nil if selected player does not exist' do
      result = game.validate_opponent('3')
      expect(result).to eq nil
    end
  end

  describe '#game_update_message' do
    before do
      game.last_turn_opponent = player2
    end

    context 'when the current player took cards from the opponent' do
      before do
        game.last_turn_card_taken = '3'
        game.last_turn_books = []
      end

      it 'returns the correct message for the current player' do
        expect(game.game_update_message(player1)).to eq "You took 3's from your opponent."
      end

      it 'returns the correct message for the opponent' do
        expect(game.game_update_message(player2)).to eq "Your 3's were taken by Player 1."
      end
    end

    context 'when the current player did not take any cards and had to "Go Fish"' do
      before do
        game.last_turn_card_taken = nil
        game.last_turn_books = []
      end

      it 'returns the correct message for the current player' do
        expect(game.game_update_message(player1)).to eq 'Go Fish! No cards were taken.'
      end

      it 'returns the correct message for the opponent' do
        expect(game.game_update_message(player2)).to eq 'Player 1 had to Go Fish!'
      end
    end

    context 'when books were made during the turn' do
      before do
        game.last_turn_card_taken = '3'
        game.last_turn_books = ['3']
      end

      it 'returns the correct message for the current player including books' do
        expect(game.game_update_message(player1)).to eq "You took 3's from your opponent.\nYou made books with: 3"
      end
    end

    context 'for other players' do
      let(:player3) { Player.new(name: 'Player 3') }
      let(:game_with_three_players) { Game.new([player1, player2, player3]) }

      before do
        game_with_three_players.current_player = player1
        game_with_three_players.last_turn_opponent = player2
        game_with_three_players.last_turn_card_taken = '3'
        game_with_three_players.last_turn_books = []
      end

      it 'returns the correct message for other players when cards were taken' do
        expect(game_with_three_players.game_update_message(player3)).to eq "Player 1 took 3's from Player 2."
      end

      it 'returns the correct message for other players when no cards were taken' do
        game_with_three_players.last_turn_card_taken = nil
        expect(game_with_three_players.game_update_message(player3)).to eq 'Player 1 had to Go Fish!'
      end
    end
  end
end
