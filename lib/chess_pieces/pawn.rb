# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'

class Pawn
  include Blockable
  include Pathable

  attr_reader :name, :color, :symbol, :relative_move_idxs
  attr_accessor :moves_made, :in_play

  # RELATIVE_MOVE_IDXS = @color == 'white' ? [[-1, 0], [-2, 0], [-1, -1], [-1, 1]] : [[1, 0], [2, 0], [1, 1], [1, -1]]

  def initialize(color)
    @name = 'pawn'
    @color = color
    @symbol = @color == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
    @relative_move_idxs = @color == 'white' ? [[-1, 0], [-1, -1], [-1, 1]] : [[1, 0], [1, 1], [1, -1]]
  end

  def blocked_in?(start, chess_board)
    forward_square = assign_forward(start, chess_board)

    forward_square.is_occupied ? !can_move_diagonally?(start, chess_board) : false
  end

  def legal_move?(start, target, chess_board)
    return false unless valid_target?(start, target, chess_board)

    if @moves_made == 0 && opening_double_move?(start, target)
      evaluate_path(start, target, chess_board)
    else
      evaluate_target(start, target)
    end
  end

  def can_move_diagonally?(start, chess_board)
    color = start.occupying_piece.color

    forward_left = assign_forward_left(start, chess_board)
    forward_right = assign_forward_right(start, chess_board)

    [forward_left, forward_right].one? do |potential_square|
      next if potential_square.nil?

      potential_square.is_occupied && potential_square.occupying_piece.color != color
    end
  end

  def evaluate_target(start, target)
    color = start.occupying_piece.color

    if start.column_index == target.column_index
      !target.is_occupied
    else
      target.is_occupied && target.occupying_piece.color != color
    end
  end

  def evaluate_path(start, target, chess_board)
    index_adjustment = @color == 'white' ? [-1, 0] : [1, 0]

    path = build_path(start, target, chess_board, index_adjustment)

    path.all? { |position| !position.is_occupied }
  end

  def opening_double_move?(start, target)
    (start.row_index - target.row_index).abs == 2 && start.column_index == target.column_index
  end

  def assign_forward(start, chess_board)
    @color == 'white' ? chess_board[start.row_index - 1][start.column_index] : chess_board[start.row_index + 1][start.column_index]
  end

  def assign_forward_left(start, chess_board)
    f_left_row_index = @color == 'white' ? start.row_index - 1 : start.row_index + 1
    f_left_col_index = @color == 'white' ? start.column_index - 1 : start.column_index + 1

    chess_board[f_left_row_index][f_left_col_index] unless invalid_indices?(f_left_row_index, f_left_col_index)
  end

  def assign_forward_right(start, chess_board)
    f_right_row_index = @color == 'white' ? start.row_index - 1 : start.row_index + 1
    f_right_col_index = @color == 'white' ? start.column_index + 1 : start.column_index - 1

    chess_board[f_right_row_index][f_right_col_index] unless invalid_indices?(f_right_row_index, f_right_col_index)
  end

  def valid_target?(start, target, chess_board)
    return true if @moves_made == 0 && opening_double_move?(start, target)

    potential_next_positions = get_direct_adjacents(@relative_move_idxs, start, chess_board)

    potential_next_positions.one? { |position| position == target }
  end
end
