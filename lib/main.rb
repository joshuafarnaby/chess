# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true

10.times do
  current_color = white_turn ? 'white' : 'black'

  chess_game.take_turn(current_color)

  chess_game.display_in_terminal

  white_turn = !white_turn
end
