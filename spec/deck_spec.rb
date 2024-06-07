# frozen_string_literal: true

require_relative 'spec_helper'
require_relative '../lib/deck'

RSpec.describe Deck do
  let(:deck) { Deck.new([]) }

  describe '#initialize' do
    it 'should respond to cards' do
      expect(deck).to respond_to :cards
    end
  end

  describe '#make_cards' do
    it 'should populate the deck with cards' do
      deck.cards = deck.make_cards
      deck_size = deck.cards.size
      expect(deck_size).to eq 52
    end
  end
end
