# frozen_string_literal: true

module Blockable
  def blocked?(indicies_array, start, chess_board)
    color = start.occupying_piece.color
    directly_adjacent = get_direct_adjacents(indicies_array, start, chess_board)

    directly_adjacent.all? do |postion|
      postion.is_occupied && postion.occupying_piece.color == color
    end
  end

  def get_direct_adjacents(indicies_array, start, chess_board, adjacents_array = [])
    indicies_array.each do |idx_array|
      row_index = start.row_index + idx_array[0]
      column_index = start.column_index + idx_array[1]

      next if invalid_indices?(row_index, column_index)

      adjacents_array.push(chess_board[row_index][column_index])
    end

    adjacents_array
  end

  def invalid_indices?(row_index, column_index)
    (row_index > 7 || column_index > 7) || (row_index < 0 || column_index < 0)
  end
end
