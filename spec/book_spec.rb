# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/book'
require_relative '../lib/card'

RSpec.describe Book do
  let(:card1) { Card.new('A', 'S') }
  let(:card2) { Card.new('A', 'H') }
  let(:book) { Book.new([card1, card2]) }

  describe '#initialize' do
    it 'creates an empty book' do
      expect(book.cards).to eq([card1, card2])
    end
  end

  describe '#rank' do
    it 'returns the rank of the book' do
      expect(book.rank).to eq('A')
    end
  end
end
