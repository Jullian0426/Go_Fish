# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/deck'

RSpec.describe Deck do
  let(:deck) { Deck.new([]) }

  describe '#initialize' do
    it 'should respond to cards' do
      expect(deck).to respond_to :cards
    end
  end

  def deck_size
    deck.cards.size
  end

  before do
    deck.cards = deck.make_cards
  end

  describe '#make_cards' do
    it 'should populate the deck with cards' do
      expect(deck_size).to eq 52
    end
  end

  describe '#deal' do
    it 'should remove the top card' do
      dealt_card = deck.deal
      expect(dealt_card).to respond_to :rank
      expect(deck_size).to eq 51
    end
  end

  describe '#shuffle' do
    it 'randomized the order of cards' do
      original_cards = deck.cards.dup
      deck.shuffle(Random.new(1))
      expect(deck.cards).to_not eq original_cards
    end
  end
end
