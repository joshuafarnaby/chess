# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true

current_player = white_turn ? 'white' : 'black'

pos = chess_game.get_square_with_piece_to_move(current_player)
p pos
