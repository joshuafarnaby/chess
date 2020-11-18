# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/gettable.rb'

class Rook
  include Convertable
  include Gettable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made

  def initialize(color)
    @name = 'rook'
    @color = color
    @symbol = @color == 'white' ? "\u2656" : "\u265C"
    @in_play = true
    @moves_made = 0
  end

  def legal_move?(start, target, chess_board)
    return false unless same_rank?(start, target) || same_file?(start, target)

    path_is_clear?(start, target, chess_board)
  end

  def blocked_in?(start_square, chess_board)
    adjacent_squares_arr = get_hv_adjacents(start_square, chess_board).filter! { |square| !square.nil? }

    adjacent_squares_arr.all? do |square|
      square.is_occupied && square.occupying_piece.color == start_square.occupying_piece.color
    end
  end

  def path_is_clear?(start, target, chess_board)
    path_to_target = path_to_target(start, target, chess_board)

    # p path_to_target

    path_to_target.all? { |square| !square.is_occupied }
  end

  def path_to_target(start, target, chess_board)
    same_rank?(start, target) ? horizontal_path(start, target, chess_board) : vertical_path(start, target, chess_board)
  end

  def horizontal_path(start, target, chess_board, path_arr = [])
    start_row_index = gets_row_index(start.position)
    start_column_index = gets_column_index(start.position)
    target_columm_index = gets_column_index(target.position)

    next_column_index = start_column_index > target_columm_index ? start_column_index - 1 : start_column_index + 1
    next_square = chess_board[start_row_index][next_column_index]

    return path_arr if next_square == target

    path_arr.push(next_square)

    horizontal_path(next_square, target, chess_board, path_arr)
  end

  def vertical_path(start, target, chess_board, path_arr = [])
    start_row_index = gets_row_index(start.position)
    start_column_index = gets_column_index(start.position)
    target_row_index = gets_row_index(target.position)

    next_row_index = start_row_index > target_row_index ? start_row_index - 1 : start_row_index + 1
    next_square = chess_board[next_row_index][start_column_index]

    return path_arr if next_square == target

    path_arr.push(next_square)

    vertical_path(next_square, target, chess_board, path_arr)
  end

  def same_rank?(start, target)
    start.position[1] == target.position[1]
  end

  def same_file?(start, target)
    start.position[0] == target.position[0]
  end
end
