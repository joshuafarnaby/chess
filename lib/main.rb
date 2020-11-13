# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true

current_player = white_turn ? 'white' : 'black'

chess_game.take_turn(current_player)
