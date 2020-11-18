# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true
current_color = white_turn ? 'white' : 'black'

chess_game.take_turn(current_color)

chess_game.display_in_terminal

# 4.times do
#   current_player = white_turn ? 'white' : 'black'

#   s = chess_game.gets_move_start_position(current_player)
#   t = chess_game.gets_move_target_position(s, current_player)

#   chess_game.execute_move(s, t)

#   chess_game.display_in_terminal

#   white_turn = !white_turn
# end
