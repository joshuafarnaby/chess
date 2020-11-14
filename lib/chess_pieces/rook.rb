# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

class Rook
  include Convertable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made

  def initialize(color)
    @name = 'rook'
    @color = color
    @symbol = @color == 'white' ? "\u2656" : "\u265C"
    @in_play = true
    @moves_made = 0
  end

  def move_is_legal?(_start_pos, _end_pos, _chess_board, _current_player)
    true
  end

  def blocked_in?(board_square, chess_board, curr_player)
    p 'here'

    blocked = true

    adjacents = [[-1, 0], [0, 1], [+1, 0], [0, -1]]
    index_of_rook = convert_filerank_to_index(board_square.position)

    adjacents.each do |element|
      adjacent_index = [index_of_rook[0] + element[0], index_of_rook[1] + element[1]]

      p adjacent_index

      next if adjacent_index.any? { |val| val.negative? || val > 7 }

      position_on_board = chess_board[adjacent_index[0]][adjacent_index[1]]

      blocked = false unless position_on_board.is_occupied
      blocked = false if position_on_board.is_occupied && position_on_board.occupying_piece.color != curr_player
    end

    blocked
  end
end
