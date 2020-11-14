# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true
current_player = white_turn ? 'white' : 'black'

chess_game.gets_starter_square(current_player)

# 2.times do
#   current_player = white_turn ? 'white' : 'black'

#   chess_game.take_turn(current_player)

#   chess_game.display_in_terminal

#   white_turn = !white_turn
# end
