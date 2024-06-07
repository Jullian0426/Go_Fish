# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  describe '#initialize' do
    it 'responds to suit, rank, and numerical rank' do
      card = Card.new('4', 'H')
      expect(card).to respond_to :suit
      expect(card).to respond_to :rank
      expect(card).to respond_to :numerical_rank
    end
  end

  describe '#==' do
    before do
      @card1 = Card.new('4', 'H')
      @card2 = Card.new('4', 'C')
      @card3 = Card.new('5', 'C')
    end

    it 'return true if ranks are equal and false if not' do
      expect(@card1 == @card2).to eq true
      expect(@card1 == @card3).to eq false
    end
  end
end
