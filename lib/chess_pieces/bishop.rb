# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/blockable.rb'

class Bishop
  include Blockable

  DIRECT_ADJACENT = [
    [-1, 1],
    [1, 1],
    [1, -1],
    [-1, -1]
  ].freeze

  attr_reader :name, :color, :symbol
  attr_accessor :in_play, :moves_made

  def initialize(color)
    @name = 'bishop'
    @color = color
    @symbol = @color == 'white' ? "\u2657" : "\u265D"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(start, chess_board)
    blocked?(DIRECT_ADJACENT, start, chess_board)

    # color = start.occupying_piece.color
    # adjacent_positions = generate_adjacent_positions(start, chess_board)

    # adjacent_positions.all? do |position|
    #   position.is_occupied && position.occupying_piece.color == color
    # end
  end

  def legal_move?(start, target, chess_board)
    return true if generate_adjacent_positions(start, chess_board).one? do |position|
      position == target
    end

    evaluate_path(start, target, chess_board)
  end

  private

  def evaluate_path(start, target, chess_board)
    path = move_path(start, target, chess_board)

    # p path

    !path.nil? && path_is_clear?(path)
  end

  def move_path(start, target, chess_board)
    DIRECT_ADJACENT.each do |array|
      path = build_path(start, target, chess_board, array)

      p path

      return path unless path.nil?
    end

    nil
  end

  def build_path(start, target, chess_board, array)
    current_row_index = gets_row_index(start.position)
    current_column_index = gets_column_index(start.position)

    path = []
    iteration_counter = 1

    loop do
      next_row_index = current_row_index + (array[0] * iteration_counter)
      next_column_index = current_column_index + (array[1] * iteration_counter)

      break if invalid_indices?(next_row_index, next_column_index)

      return path if chess_board[next_row_index][next_column_index] == target

      path.push(chess_board[next_row_index][next_column_index])
      iteration_counter += 1
    end

    nil
  end

  def path_is_clear?(path)
    path.all? { |position| !position.is_occupied }
  end

  def generate_adjacent_positions(start, chess_board, adjacents = [])
    current_row_index = gets_row_index(start.position)
    current_column_index = gets_column_index(start.position)

    DIRECT_ADJACENT.each do |array|
      adj_row_index = current_row_index + array[0]
      adj_column_index = current_column_index + array[1]

      next if invalid_indices?(adj_row_index, adj_column_index)

      adjacents.push(chess_board[adj_row_index][adj_column_index])
    end

    adjacents
  end

  def invalid_indices?(row_index, column_index)
    return true if row_index > 7 || column_index > 7
    return true if row_index < 0 || column_index < 0

    false
  end
end
