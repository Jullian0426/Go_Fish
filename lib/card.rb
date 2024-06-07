# frozen_string_literal: true

# Represents a playing card
class Card
  attr_reader :suit, :rank

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[H D C S].freeze

  def initialize(rank, suit)
    @suit = suit
    @rank = rank
  end

  def value
    @value ||= RANKS.index(rank)
  end

  def ==(other)
    other.rank == rank && other.suit == suit
  end
end
