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
    current_row_index = gets_row_index(start.position)
    current_column_index = gets_column_index(start.position)

    indicies_array.each do |idx_array|
      row_index = current_row_index + idx_array[0]
      column_index = current_column_index + idx_array[1]

      next if invalid_indices?(row_index, column_index)

      adjacents_array.push(chess_board[row_index][column_index])
    end

    # p adjacents_array

    adjacents_array
  end

  def invalid_indices?(row_index, column_index)
    return true if row_index > 7 || column_index > 7
    return true if row_index < 0 || column_index < 0

    false
  end
end
