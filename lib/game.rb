# frozen_string_literal: true

# Represents the game of Go Fish
class Game
  attr_reader :players

  def initialize(players)
    @players = players
  end
end
