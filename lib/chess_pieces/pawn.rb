# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

class Pawn
  include Convertable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made, :in_play

  def initialize(color)
    @name = 'pawn'
    @color = color
    @symbol = @color == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
  end

  def can_legally_move?(start_square, target_square, chess_board)
    forward = set_forward(start_square, chess_board)
    forward_double = set_forward_double(start_square, chess_board)

    forward_left = set_forward_left(start_square, chess_board)
    forward_right = set_forward_right(start_square, chess_board)

    potential_moves = @moves_made == 0 ? [forward, forward_double, forward_left, forward_right] : [forward, forward_left, forward_right]

    return false unless valid_target_square?(potential_moves, target_square)

    if target_square == forward
      return false if forward.is_occupied
    elsif target_square == forward_double
      return false unless !forward_double.is_occupied && !forward.is_occupied
    elsif target_square == forward_left
      unless forward_left.is_occupied && forward_left.occupying_piece.color != start_square.occupying_piece.color
        return false
      end
    elsif target_square == forward_right
      unless forward_right.is_occupied && forward_right.occupying_piece.color != start_square.occupying_piece.color
        return false
      end
    end

    true
  end

  def valid_target_square?(position_array, target_square)
    position_array.one? { |square| square == target_square }
  end

  def blocked_in?(board_square, chess_board)
    forward_square = set_forward(board_square, chess_board)

    if forward_square.is_occupied
      forward_left = set_forward_left(board_square, chess_board)
      forward_right = set_forward_right(board_square, chess_board)

      !can_move_diagonally?(board_square, forward_left, forward_right)
    else
      false
    end
  end

  def can_move_diagonally?(board_square, forward_left, forward_right)
    current_color = board_square.occupying_piece.color

    [forward_left, forward_right].one? do |potential_square|
      next if potential_square.nil?

      potential_square.is_occupied && potential_square.occupying_piece.color != current_color
    end
  end

  def set_forward(start_square, chess_board)
    color = start_square.occupying_piece.color
    row_index = gets_row_index(start_square.position)
    column_index = gets_column_index(start_square.position)

    color == 'white' ? chess_board[row_index - 1][column_index] : chess_board[row_index + 1][column_index]
  end

  def set_forward_double(start_square, chess_board)
    color = start_square.occupying_piece.color
    row_index = gets_row_index(start_square.position)
    column_index = gets_column_index(start_square.position)

    color == 'white' ? chess_board[row_index - 2][column_index] : chess_board[row_index + 2][column_index]
  end

  def set_forward_left(start_square, chess_board)
    color = start_square.occupying_piece.color
    row_index = gets_row_index(start_square.position)
    column_index = gets_column_index(start_square.position)

    return nil if column_index == 0 && color == 'white'

    color == 'white' ? chess_board[row_index - 1][column_index - 1] : chess_board[row_index + 1][column_index + 1]
  end

  def set_forward_right(start_square, chess_board)
    color = start_square.occupying_piece.color
    row_index = gets_row_index(start_square.position)
    column_index = gets_column_index(start_square.position)

    return nil if column_index == 0 && color == 'black'

    color == 'white' ? chess_board[row_index - 1][column_index + 1] : chess_board[row_index + 1][column_index - 1]
  end
end
