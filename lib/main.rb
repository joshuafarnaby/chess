# frozen_string_literal: true

require_relative 'chess'

chess_game = Chess.new
chess_game.display_in_terminal

white_turn = true

3.times do
  current_color = white_turn ? 'white' : 'black'

  chess_game.take_turn(current_color)

  chess_game.display_in_terminal

  white_turn = !white_turn
end

# def collect_numbers(num, arr = [])
#   return arr if num < 1

#   arr.push(num)

#   collect_numbers(num - 1, arr)
# end

# p collect_numbers(10)
