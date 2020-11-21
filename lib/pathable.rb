# frozen_string_literal: true

module Pathable
  def build_path(start, target, chess_board, index_adjustment, path = [])
    next_row_index = start.row_index + index_adjustment[0]
    next_column_index = start.column_index + index_adjustment[1]

    next_position = chess_board[next_row_index][next_column_index]

    return path if next_position == target

    path.push(next_position)

    build_path(next_position, target, chess_board, index_adjustment, path)
  end

  def determine_direction(start, target)
    if same_file?(start, target)
      start.row_index > target.row_index ? [-1, 0] : [1, 0]
    elsif same_rank?(start, target)
      start.column_index > target.column_index ? [0, - 1] : [0, 1]
    else
      evaluate_diagonal_path(start, target)
    end
  end

  def evaluate_diagonal_path(start, target)
    if start.row_index > target.row_index
      start.column_index > target.column_index ? [-1, -1] : [-1, 1]
    else
      start.column_index > target.column_index ? [1, -1] : [1, 1]
    end
  end

  def same_rank?(start, target)
    start.position[1] == target.position[1]
  end

  def same_file?(start, target)
    start.position[0] == target.position[0]
  end

  def diagonally?(start, target)
    (start.row_index - target.row_index).abs == (start.column_index - target.column_index).abs
  end
end
