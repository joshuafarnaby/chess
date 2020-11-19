# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

class Knight
  include Convertable

  attr_reader :name, :color, :symbol
  attr_accessor :in_play, :moves_made

  MOVE_LIST = [
    [-2, 1],
    [-1, 2],
    [1, 2],
    [2, 1],
    [2, -1],
    [1, -2],
    [-1, -2],
    [-2, -1]
  ].freeze

  def initialize(color)
    @name = 'knight'
    @color = color
    @symbol = @color == 'white' ? "\u2658" : "\u265E"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(_start, _chess_board)
    false
  end

  def legal_move?(start, target, chess_board)
    color = start.occupying_piece.color
    reachable_positions = generate_reachable_positions(start, chess_board)

    p reachable_positions

    reachable_positions.one? do |position|
      !position.is_occupied || (position.is_occupied && position.occupying_piece.color != color) if position == target
    end
  end

  def generate_reachable_positions(square, chess_board, reachable_positions = [])
    current_row_idx = gets_row_index(square.position)
    current_column_idx = gets_column_index(square.position)

    p [current_row_idx, current_column_idx]

    MOVE_LIST.each do |sub_arr|
      new_row_idx = current_row_idx + sub_arr[0]
      new_column_idx = current_column_idx + sub_arr[1]

      next if invalid_positions?(new_row_idx, new_column_idx)

      reachable_positions.push(chess_board[new_row_idx][new_column_idx])
    end

    reachable_positions
  end

  def invalid_positions?(new_row_idx, new_column_idx)
    return true if new_row_idx > 7 || new_column_idx > 7
    return true if new_row_idx < 0 || new_column_idx < 0

    false
  end
end
