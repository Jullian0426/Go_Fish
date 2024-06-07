# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/deck'

RSpec.describe Game do
  let(:player2) { Player.new(name: 'Player 2') }
  let(:player1) { Player.new(name: 'Player 1') }
  let(:game) { Game.new([player1, player2]) }

  describe '#initialize' do
    it 'responds to players' do
      expect(game).to respond_to :players
    end
  end

  describe '#start' do
    it 'should shuffle the deck' do
      
    end
  end
end
