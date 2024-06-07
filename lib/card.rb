# frozen_string_literal: true

# Represents a playing card
class Card
  attr_reader :suit, :rank, :numerical_rank

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[H D C S].freeze

  def initialize(rank, suit)
    @suit = suit
    @rank = rank
    @numerical_rank = RANKS.index(rank)
  end

  def ==(other)
    other.rank == rank
  end
end
