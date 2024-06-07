# frozen_string_literal: true

# Represents the game of Go Fish
class Game
  attr_reader :players

  def initialize(players)
    @players = players
  end

  def start
    deck.shuffle
    players.each do |player|
      5.times { player.hand << deck.deal }
    end
  end

  def deck
    @deck ||= Deck.new
  end
end
