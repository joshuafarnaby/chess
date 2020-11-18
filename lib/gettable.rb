# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

module Gettable
  include Convertable

  def get_hv_adjacents(square, chess_board)
    horizontal_adjacents = get_horizontal_adjacents(square, chess_board)
    vertical_adjacents = get_vertical_adjacents(square, chess_board)

    horizontal_adjacents + vertical_adjacents
  end

  def get_vertical_adjacents(square, chess_board)
    forward = get_forward(square, chess_board)
    behind = get_behind(square, chess_board)

    [forward, behind]
  end

  def get_horizontal_adjacents(square, chess_board)
    left = get_left(square, chess_board)
    right = get_right(square, chess_board)

    [left, right]
  end

  def get_forward(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    color == 'white' ? chess_board[row_index - 1][column_index] : chess_board[row_index + 1][column_index]
  end

  def get_forward_double(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    color == 'white' ? chess_board[row_index - 2][column_index] : chess_board[row_index + 2][column_index]
  end

  def get_behind(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    return nil if (row_index == 7 && color == 'white') || (row_index == 7 && color == 'black')

    color == 'white' ? chess_board[row_index + 1][column_index] : chess_board[row_index - 1][column_index]
  end

  def get_left(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    return nil if column_index == 0 && color == 'white'

    color == 'white' ? chess_board[row_index][column_index - 1] : chess_board[row_index][column_index + 1]
  end

  def get_right(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    return nil if column_index == 0 && color == 'black'

    color == 'white' ? chess_board[row_index][column_index + 1] : chess_board[row_index][column_index - 1]
  end

  def get_forward_left(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    return nil if column_index == 0 && color == 'white'

    color == 'white' ? chess_board[row_index - 1][column_index - 1] : chess_board[row_index + 1][column_index + 1]
  end

  def get_forward_right(square, chess_board)
    color = square.occupying_piece.color
    row_index = gets_row_index(square.position)
    column_index = gets_column_index(square.position)

    return nil if column_index == 0 && color == 'black'

    color == 'white' ? chess_board[row_index - 1][column_index + 1] : chess_board[row_index + 1][column_index - 1]
  end
end
