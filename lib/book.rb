# frozen_string_literal: true

require_relative 'card'

# Represents a book of playing cards
class Book
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def rank
    cards.first.rank
  end
end
