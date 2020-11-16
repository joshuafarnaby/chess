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

  def blocked_in?(board_square, chess_board, curr_player_color)
    current_position = board_square.position
    row_index = gets_row_index(current_position)
    column_index = gets_column_index(current_position)

    square_directly_ahead = curr_player_color == 'white' ? chess_board[row_index - 1][column_index] : chess_board[row_index + 1][column_index]

    # square ahead is empty - forward move can be exectued
    return false unless square_directly_ahead.is_occupied

    if square_directly_ahead.is_occupied
      # check if a diagonal move can be executed
      # if this method returns true a diagonal move can be made - so we return the opposite
      can_move_diagonally?(row_index, column_index, chess_board, curr_player_color) ? false : true
    end
  end

  def can_move_diagonally?(row_index, column_index, chess_board, curr_player_color)
    forward_left = curr_player_color == 'white' ? chess_board[row_index - 1][column_index - 1] : chess_board[row_index + 1][column_index + 1]
    forward_right = curr_player_color == 'white' ? chess_board[row_index - 1][column_index + 1] : chess_board[row_index + 1][column_index - 1]

    if chess_board[row_index][column_index].position[0] == 'A'
      # temp solution to (col index - 1) wrapping to column H and not nil
      curr_player_color == 'white' ? forward_left = nil : forward_right = nil
    end

    # nil would indicate off board
    if !forward_left.nil?
      forward_left.is_occupied && forward_left.occupying_piece.color != curr_player_color ? true : false
    elsif !forward_right.nil?
      forward_right.is_occupied && forward_right.occupying_piece.color != curr_player_color ? true : false
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
