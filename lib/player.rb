# frozen_string_literal: true

require_relative 'card'

# Represents a player of the game
class Player
  attr_reader :name, :books
  attr_accessor :hand

  def initialize(name = nil)
    @name = name
    @hand = []
    @books = []
  end

  def add_cards(cards)
    hand.push(*cards)
  end

  def remove_cards(rank)
    hand.map do |card|
      hand.delete(card) if card.rank == rank
    end
  end
end
