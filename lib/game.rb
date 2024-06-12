# frozen_string_literal: true

require_relative 'deck'

# Represents the game of Go Fish
class Game
  attr_reader :players
  attr_accessor :winner, :last_turn_opponent, :last_turn_card_taken, :last_turn_books, :current_player

  MIN_PLAYERS = 2
  STARTING_HAND = 5

  def initialize(players)
    @players = players
    @winner = nil
    @current_player = players.first
    @last_turn_opponent = nil
    @last_turn_card_taken = nil
    @last_turn_books = []
  end

  def start
    deck.shuffle
    players.each do |player|
      STARTING_HAND.times { player.hand << deck.deal }
    end
  end

  def play_round(rank, opponent)
  end

  def validate_rank(rank)
    rank if current_player.hand.any? { |card| card.rank == rank }
  end

  def validate_opponent(position)
    return nil if position.empty?

    index = position.to_i - 1
    return nil if index.negative? || index >= players.size || players[index] == current_player

    players[index]
  end

  def game_update_message(player)
    if player == current_player
      update_current_player
    elsif player == last_turn_opponent
      update_opponent
    else
      update_other
    end
  end

  def update_current_player
    message = if last_turn_card_taken
                "You took #{last_turn_card_taken}'s from your opponent."
              else
                'Go Fish! No cards were taken.'
              end
    message += "\nYou made books with: #{last_turn_books.join(', ')}" if last_turn_books.any?
    message
  end

  def update_opponent
    if last_turn_card_taken
      "Your #{last_turn_card_taken}'s were taken by #{current_player.name}."
    else
      "#{current_player.name} had to Go Fish!"
    end
  end

  def update_other
    if last_turn_card_taken
      "#{current_player.name} took #{last_turn_card_taken}'s from #{last_turn_opponent.name}."
    else
      "#{current_player.name} had to Go Fish!"
    end
  end

  def deck
    @deck ||= Deck.new
  end
end
