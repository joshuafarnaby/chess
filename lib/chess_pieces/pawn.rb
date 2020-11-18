# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/gettable.rb'

class Pawn
  include Convertable
  include Gettable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made, :in_play

  def initialize(color)
    @name = 'pawn'
    @color = color
    @symbol = @color == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
  end

  def legal_move?(start_square, target_square, chess_board)
    potential_moves_array = determine_potential_next_positions(start_square, chess_board)

    return false unless valid_target_square?(potential_moves_array, target_square)

    move_is_possible?(start_square, target_square, potential_moves_array)
  end

  def move_is_possible?(start_square, target_square, potential_moves_array)
    forward = potential_moves_array[0]
    forward_left = potential_moves_array[1]
    forward_right = potential_moves_array[2]
    forward_double = potential_moves_array[3] if potential_moves_array.length == 4

    if target_square == forward
      return false if forward.is_occupied
    elsif target_square == forward_double
      return false unless !forward_double.is_occupied && !forward.is_occupied
    else
      return possible_diagonal_move?(start_square, target_square, forward_left, forward_right)
    end

    true
  end

  def possible_diagonal_move?(start_square, target_square, forward_left, forward_right)
    if target_square == forward_left
      forward_left.is_occupied && forward_left.occupying_piece.color != start_square.occupying_piece.color
    else
      forward_right.is_occupied && forward_right.occupying_piece.color != start_square.occupying_piece.color
    end
  end

  def determine_potential_next_positions(start_square, chess_board)
    forward = get_forward(start_square, chess_board)
    forward_left = get_forward_left(start_square, chess_board)
    forward_right = get_forward_right(start_square, chess_board)

    return [forward, forward_left, forward_right] if @moves_made > 0

    forward_double = get_forward_double(start_square, chess_board)
    [forward, forward_left, forward_right, forward_double]
  end

  def blocked_in?(board_square, chess_board)
    forward_square = get_forward(board_square, chess_board)

    if forward_square.is_occupied
      forward_left = get_forward_left(board_square, chess_board)
      forward_right = get_forward_right(board_square, chess_board)

      !can_move_diagonally?(board_square, forward_left, forward_right)
    else
      false
    end
  end

  def can_move_diagonally?(board_square, forward_left, forward_right)
    current_color = board_square.occupying_piece.color

    [forward_left, forward_right].one? do |potential_square|
      next if potential_square.nil?

      potential_square.is_occupied && potential_square.occupying_piece.color != current_color
    end
  end

  def valid_target_square?(position_array, target_square)
    position_array.one? { |square| square == target_square }
  end
end
