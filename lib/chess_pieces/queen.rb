# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/gettable.rb'

class Queen
  include Blockable
  include Convertable

  attr_reader :name, :color, :symbol
  attr_accessor :in_play, :moves_made

  DIRECT_ADJACENT = [
    [-1, 1],
    [0, 1],
    [1, 1],
    [1, 0],
    [1, -1],
    [0, -1],
    [-1, -1],
    [-1, 0]
  ].freeze

  def initialize(color)
    @name = 'queen'
    @color = color
    @symbol = @color == 'white' ? "\u2655" : "\u265B"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(start, chess_board)
    blocked?(DIRECT_ADJACENT, start, chess_board)
  end

  def legal_move?(start, target, chess_board)
    target_position_valid?(start, target) && path_is_clear?(start, target, chess_board)
  end

  def path_is_clear?(start, target, chess_board)
    index_adjustment = determine_direction(start, target)

    path_to_target = build_path(start, target, chess_board, index_adjustment)

    p path_to_target

    path_to_target.all? { |position| !position.is_occupied }
  end

  def determine_direction(start, target)
    start_row_index =  gets_row_index(start.position)
    start_column_index = gets_column_index(start.position)

    target_row_index = gets_row_index(target.position)
    target_column_index = gets_column_index(target.position)

    if same_file?(start, target)
      start_row_index > target_row_index ? [-1, 0] : [1, 0]
    elsif same_rank?(start, target)
      start_column_index > target_column_index ? [0, - 1] : [0, 1]
    else
      evaluate_diagonal_path([start_row_index, start_column_index], [target_row_index, target_column_index])
    end
  end

  def build_path(start, target, chess_board, index_adjustment)
    if same_file?(start, target) || same_rank?(start, target)
      build_straight_path(start, target, chess_board, index_adjustment)
    else
      build_diagonal_path(start, target, chess_board, index_adjustment)
    end
  end

  def build_straight_path(start, target, chess_board, array, path = [])
    next_row_index = gets_row_index(start.position) + array[0]
    next_column_index = gets_column_index(start.position) + array[1]

    next_position = chess_board[next_row_index][next_column_index]

    return path if next_position == target

    path.push(next_position)

    build_straight_path(next_position, target, chess_board, array, path)
  end

  def build_diagonal_path(start, target, chess_board, array, path = [])
    start_indicies = [gets_row_index(start.position), gets_column_index(start.position)]

    distance = 1

    loop do
      next_row_index = start_indicies[0] + (array[0] * distance)
      next_column_index = start_indicies[1] + (array[1] * distance)

      return path if chess_board[next_row_index][next_column_index] == target

      path.push(chess_board[next_row_index][next_column_index])
      distance += 1
    end
  end

  def evaluate_diagonal_path(start_indicies, target_indicies)
    if start_indicies[0] > target_indicies[0]
      start_indicies[1] > target_indicies[1] ? [-1, -1] : [-1, 1]
    else
      start_indicies[1] > target_indicies[1] ? [1, -1] : [1, 1]
    end
  end

  def target_position_valid?(start, target)
    same_rank?(start, target) || same_file?(start, target) || diagonally?(start, target)
  end

  def same_rank?(start, target)
    start.position[1] == target.position[1]
  end

  def same_file?(start, target)
    start.position[0] == target.position[0]
  end

  def diagonally?(start, target)
    start_row_index =  gets_row_index(start.position)
    start_column_index = gets_column_index(start.position)

    target_row_index = gets_row_index(target.position)
    target_column_index = gets_column_index(target.position)

    (start_row_index - target_row_index).abs == (start_column_index - target_column_index).abs
  end
end
