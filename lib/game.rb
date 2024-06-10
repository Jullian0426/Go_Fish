# frozen_string_literal: true

# Represents the game of Go Fish
class Game
  attr_reader :players, :current_player
  attr_accessor :winner

  def initialize(players)
    @players = players
    @winner = nil
    @current_player = players.first
  end

  def start
    deck.shuffle
    players.each do |player|
      5.times { player.hand << deck.deal }
    end
  end

  def validate_rank(rank)
    current_player.hand.any? { |card| card.rank == rank }
  end

  def deck
    @deck ||= Deck.new
  end
end
