# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/player'

class MockCard
  attr_accessor :rank

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end
end

RSpec.describe Player do
  let(:player) { Player.new(name: 'Player') }
  let(:mock_card1) { MockCard.new('3', 'H') }
  let(:mock_card2) { MockCard.new('4', 'C') }

  describe '#initialize' do
    it 'responds to name, hand, and books' do
      expect(player).to respond_to :name
      expect(player).to respond_to :hand
      expect(player).to respond_to :books
    end
  end

  describe '#add_cards' do
    it 'adds a single card to hand' do
      player.add_cards(mock_card1)
      expect(player.hand).to include(mock_card1)
      expect(player.hand.size).to eq 1
    end

    it 'adds two cards to hand' do
      player.add_cards([mock_card1, mock_card2])
      expect(player.hand).to include(mock_card1, mock_card2)
      expect(player.hand.size).to eq 2
    end
  end

  describe '#remove_by_rank' do
    before do
      player.hand = [mock_card1, mock_card2]
    end

    it 'removes a single card from hand' do
      player.remove_by_rank('3')
      expect(player.hand).to_not include(mock_card1)
      expect(player.hand.size).to eq 1
    end

    it 'removes two cards from hand' do
      player.remove_by_rank('3')
      player.remove_by_rank('4')
      expect(player.hand).to_not include(mock_card1, mock_card2)
      expect(player.hand.size).to eq 0
    end
  end

  describe '#has_rank?' do
    before do
      player.hand = [mock_card1, mock_card2]
    end

    it 'returns true if hand contains cards of specified rank' do
      result = player.hand_has_rank?('3')
      expect(result).to eq true
    end

    it 'returns false if hand does not contain cards of specified rank' do
      result = player.hand_has_rank?('5')
      expect(result).to eq false
    end
  end
end
