# frozen_string_literal: true

require_relative 'server'

server = Server.new
server.start
loop do
  server.accept_new_client
  server.create_player_if_possible
  game = server.create_game_if_possible
  server.run_game(game) if game
  begin
  rescue
    server.stop
  end
end
