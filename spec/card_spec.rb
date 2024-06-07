# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  let(:card1) { Card.new('4', 'H') }

  describe '#initialize' do
    it 'responds to suit, rank, and value' do
      expect(card1).to respond_to :suit
      expect(card1).to respond_to :rank
      expect(card1).to respond_to :value
    end
  end

  describe 'value' do
    it 'should return the cards value' do
      expect(card1.value).to eq 2
    end
  end

  describe '#==' do
    before do
      @card2 = Card.new('4', 'H')
      @card3 = Card.new('5', 'C')
    end

    it 'return true if ranks and suits are equal and false if not' do
      expect(card1 == @card2).to eq true
      expect(card1 == @card3).to eq false
    end
  end
end
