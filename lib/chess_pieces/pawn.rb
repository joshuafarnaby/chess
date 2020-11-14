# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'

class Pawn
  include Convertable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made

  def initialize(color)
    @name = 'pawn'
    @color = color
    @symbol = @color == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
  end

  def move_is_legal?(start_pos, end_pos, chess_board, curr_player)
    start_indices = convert_filerank_to_index(start_pos.position)
    end_indicies = convert_filerank_to_index(end_pos.position)

    return false unless moving_forwards?(start_indices, end_indicies, curr_player)

    if end_indicies[1] == start_indices[1] + 1 || end_indicies[1] == start_indices[1] - 1
      valid_diagonal_move?(end_indicies, chess_board, curr_player) ? true : false
    else
      valid_vertical_move?(start_indices, end_indicies, curr_player) ? true : false
    end
  end

  def moving_forwards?(start_indices, end_indices, curr_player)
    curr_player == 'white' ? start_indices[0] > end_indices[0] : start_indices[0] < end_indices[0]
  end

  def valid_diagonal_move?(end_indicies, chess_board, curr_player)
    target_square = chess_board[end_indicies[0]][end_indicies[1]]
    target_square.is_occupied && target_square.occupying_piece.team != curr_player
  end

  def valid_vertical_move?(start_indices, end_indices, curr_player)
    if curr_player == 'white'
      @moves_made < 1 ? start_indices[0] - end_indices[0] <= 2 : start_indices[0] - end_indices[0] == 1
    else
      @moves_made < 1 ? end_indices[0] - start_indices[0] <= 2 : end_indices[0] - start_indices[0] == 1
    end
  end

  def blocked_in?(board_square, chess_board, _curr_player)
    board_indicies = convert_filerank_to_index(board_square.position)

    if @color == 'white'
      return false if chess_board[board_indicies[0] - 1][board_indicies[1]].is_occupied == false
    else
      return false if chess_board[board_indicies[0] + 1][board_indicies[1]].is_occupied == false
    end

    true
  end

  def path_is_blocked?(_start_square, _target_square, _chess_board)
    true
  end
end
