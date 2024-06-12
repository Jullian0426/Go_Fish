# frozen_string_literal: true

require_relative 'deck'
require_relative 'book'

# Represents the game of Go Fish
class Game
  attr_reader :players
  attr_accessor :winner, :last_turn_opponent, :last_turn_card_taken, :last_turn_book, :current_player

  MIN_PLAYERS = 2
  STARTING_HAND = 5

  def initialize(players)
    @players = players
    @winner = nil
    @current_player = players.first
    @last_turn_opponent = nil
    @last_turn_card_taken = nil
    @last_turn_book = nil
  end

  def start
    deck.shuffle
    players.each do |player|
      STARTING_HAND.times { player.hand << deck.deal }
    end
  end

  def play_round(rank, opponent)
    reset_turn(opponent)
    if opponent.hand_has_rank?(rank)
      take_cards(rank, opponent)
    else
      go_fish
    end
    finalize_turn
  end

  def reset_turn(opponent)
    @last_turn_opponent = opponent
    @last_turn_card_taken = nil
    @last_turn_book = nil
  end

  def take_cards(rank, opponent)
    cards_to_move = opponent.remove_by_rank(rank)
    current_player.add_cards(cards_to_move)
    @last_turn_card_taken = rank
  end

  def go_fish
    drawn_card = deck.deal
    current_player.add_cards([drawn_card])
  end

  def finalize_turn
    create_book_if_possible(current_player)
    update_current_player
  end

  def create_book_if_possible(player)
    ranks = player.hand.map(&:rank)
    book_rank = ranks.find { |rank| ranks.count(rank) == 4 }
    return unless book_rank

    create_book(player, book_rank)
  end

  def create_book(player, book_rank)
    book_cards = player.remove_by_rank(book_rank)
    new_book = Book.new(book_cards)
    player.books << new_book
    @last_turn_book = new_book
  end

  def update_current_player
    @current_player = players[(players.index(current_player) + 1) % players.size]
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
      message_current_player
    elsif player == last_turn_opponent
      message_opponent
    else
      message_other
    end
  end

  def message_current_player
    message = if last_turn_card_taken
                "You took #{last_turn_card_taken}'s from your opponent."
              else
                'Go Fish! No cards were taken.'
              end
    message += "\nYou made a book with: #{last_turn_book.cards.first.rank}" if last_turn_book
    message
  end

  def message_opponent
    if last_turn_card_taken
      "Your #{last_turn_card_taken}'s were taken by #{current_player.name}."
    else
      "#{current_player.name} had to Go Fish!"
    end
  end

  def message_other
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
