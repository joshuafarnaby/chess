# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

require_relative './queen'
require_relative './rook'
require_relative './knight'
require_relative './bishop'

class Pawn
  include Pathable
  include Moveable

  attr_reader :name, :color, :symbol, :relative_move_idxs
  attr_accessor :moves_made, :in_play, :en_passant

  # RELATIVE_MOVE_IDXS = @color == 'white' ? [[-1, 0], [-2, 0], [-1, -1], [-1, 1]] : [[1, 0], [2, 0], [1, 1], [1, -1]]

  def initialize(color)
    @name = 'pawn'
    @color = color
    @symbol = @color == 'white' ? "\u2659" : "\u265F"
    @moves_made = 0
    @in_play = true
    @relative_move_idxs = @color == 'white' ? [[-1, 0], [-1, -1], [-1, 1]] : [[1, 0], [1, 1], [1, -1]]
    @en_passant = nil
  end

  def execute_move(start, target, chess_obj)
    if opening_double_move?(start, target)
      execute_opening_double_move(start, target, chess_obj)
    elsif en_passant?(start, target, chess_obj)
      execute_en_passant(start, target, chess_obj)
    elsif !target.is_occupied
      execute_standard_move(start, target)
    elsif target.is_occupied
      execute_capture_move(start, target, chess_obj)
    end

    execute_promotion(target, chess_obj) if promotion_viable?(target)
  end

  def legal_move?(start, target, chess_obj)
    return false unless valid_target?(start, target, chess_obj)

    chess_board = chess_obj.chess_board

    if @moves_made == 0 && opening_double_move?(start, target)
      evaluate_path(start, target, chess_board)
    else
      evaluate_target(start, target, chess_obj)
    end
  end

  private

  def valid_target?(start, target, chess_obj)
    return false if start == target || friendly_fire?(start, target)
    return true if @moves_made == 0 && opening_double_move?(start, target)

    chess_board = chess_obj.chess_board
    potential_next_positions = get_direct_adjacents(@relative_move_idxs, start, chess_board)

    potential_next_positions.one? { |position| position == target }
  end

  def en_passant?(start, target, chess_obj)
    chess_board = chess_obj.chess_board
    adjacent_square = chess_board[start.row_index][target.column_index]

    return false unless adjacent_square.is_occupied

    current_round = chess_obj.round_number
    color = start.occupying_piece.color

    piece_to_capture = adjacent_square.occupying_piece

    return false if piece_to_capture.name != 'pawn' || piece_to_capture.color == color

    piece_to_capture.en_passant == current_round - 1
  end

  def evaluate_target(start, target, chess_obj)
    color = start.occupying_piece.color

    if start.column_index == target.column_index
      !target.is_occupied
    else
      target.is_occupied ? target.occupying_piece.color != color : en_passant?(start, target, chess_obj)
    end
  end

  def evaluate_path(start, target, chess_board)
    index_adjustment = @color == 'white' ? [-1, 0] : [1, 0]

    path = build_path(start, target, chess_board, index_adjustment)

    path.all? { |position| !position.is_occupied }
  end

  def promotion_viable?(target)
    pawn = target.occupying_piece

    target.row_index == (pawn.color == 'white' ? 0 : 7)
  end

  def gets_user_choice
    loop do
      input = gets.chomp.strip.upcase
      return input if input == 'QUEEN' || input == 'ROOK' || input == 'KNIGHT' || input == 'BISHOP'

      puts 'That input is not recognised, try again:'
    end
  end

  def fetch_class(class_name_str)
    return Queen if class_name_str == 'QUEEN'
    return Rook if class_name_str == 'ROOK'
    return Knight if class_name_str == 'KNIGHT'
    return Bishop if class_name_str == 'BISHOP'
  end

  def opening_double_move?(start, target)
    (start.row_index - target.row_index).abs == 2 && start.column_index == target.column_index
  end
end
