# frozen_string_literal: true

require_relative 'card'

# Represents a player of the game
class Player
  attr_reader :name, :books
  attr_accessor :hand

  def initialize(name:, hand: [], books: [])
    @name = name
    @hand = hand
    @books = books
  end

  def add_cards(cards)
    hand.push(*cards)
  end

  def remove_by_rank(rank)
    removed_cards = hand.select { |card| card.rank == rank }
    hand.reject! { |card| card.rank == rank }
    removed_cards
  end

  def hand_has_rank?(rank)
    hand.any? { |card| card.rank == rank }
  end
end
