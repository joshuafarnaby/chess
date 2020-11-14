# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true
current_player = white_turn ? 'white' : 'black'

5.times do
  current_player = white_turn ? 'white' : 'black'

  s = chess_game.gets_starter_square(current_player)
  t = chess_game.gets_target_square(current_player, s)

  chess_game.execute_move(s, t)

  chess_game.display_in_terminal

  white_turn = !white_turn
end
