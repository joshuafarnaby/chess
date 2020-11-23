# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

require_relative './queen'
require_relative './rook'
require_relative './knight'
require_relative './bishop'

class Pawn
  include Blockable
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

  def blocked_in?(start, chess_obj)
    chess_board = chess_obj.chess_board

    forward_square = assign_forward(start, chess_board)

    forward_square.is_occupied ? !can_move_diagonally?(start, chess_board) : false
  end

  def legal_move?(start, target, chess_obj)
    return false if start == target || friendly_fire?(start, target)

    chess_board = chess_obj.chess_board

    return false unless valid_target?(start, target, chess_board)
    return true if en_passant?(start, target, chess_obj)

    if @moves_made == 0 && opening_double_move?(start, target)
      evaluate_path(start, target, chess_board)
    else
      evaluate_target(start, target)
    end
  end

  private

  def en_passant?(start, target, chess_obj)
    chess_board = chess_obj.chess_board
    current_round = chess_obj.round_number
    color = start.occupying_piece.color

    piece_to_capture = chess_board[start.row_index][target.column_index].occupying_piece

    return false if piece_to_capture.name != 'pawn' || piece_to_capture.color == color

    piece_to_capture.en_passant == current_round - 1
  end

  def execute_opening_double_move(start, target, chess_obj)
    moving_piece = start.reset

    target.occupying_piece = moving_piece
    target.is_occupied = true

    moving_piece.en_passant = chess_obj.round_number
    moving_piece.moves_made += 1
  end

  def execute_en_passant(start, target, chess_obj)
    moving_piece = start.reset
    passing_square = chess_obj.chess_board[start.row_index][target.column_index]
    captured_piece = passing_square.reset

    target.occupying_piece = moving_piece
    target.is_occupied = true

    if captured_piece.color == 'white'
      chess_obj.white_graveyard.push(captured_piece)
    else
      chess_obj.black_graveyard.push(captured_piece)
    end
  end

  def can_move_diagonally?(start, chess_board)
    color = start.occupying_piece.color

    forward_left = assign_forward_left(start, chess_board)
    forward_right = assign_forward_right(start, chess_board)

    [forward_left, forward_right].one? do |potential_square|
      next if potential_square.nil?

      potential_square.is_occupied && potential_square.occupying_piece.color != color
    end
  end

  def evaluate_target(start, target)
    color = start.occupying_piece.color

    if start.column_index == target.column_index
      !target.is_occupied
    else
      target.is_occupied && target.occupying_piece.color != color
    end
  end

  def evaluate_path(start, target, chess_board)
    index_adjustment = @color == 'white' ? [-1, 0] : [1, 0]

    path = build_path(start, target, chess_board, index_adjustment)

    path.all? { |position| !position.is_occupied }
  end

  def execute_promotion(target, chess_obj)
    chess_obj.display_in_terminal

    puts "The pawn at #{target.position} can be promoted"
    puts 'Enter QUEEN, ROOK, KNIGHT or BISHOP:'

    user_choice_str = gets_user_choice

    new_piece_class = fetch_class(user_choice_str)
    new_piece = new_piece_class.new(target.occupying_piece.color)

    target.occupying_piece = new_piece
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

  def assign_forward(start, chess_board)
    @color == 'white' ? chess_board[start.row_index - 1][start.column_index] : chess_board[start.row_index + 1][start.column_index]
  end

  def assign_forward_left(start, chess_board)
    f_left_row_index = @color == 'white' ? start.row_index - 1 : start.row_index + 1
    f_left_col_index = @color == 'white' ? start.column_index - 1 : start.column_index + 1

    chess_board[f_left_row_index][f_left_col_index] unless invalid_indices?(f_left_row_index, f_left_col_index)
  end

  def assign_forward_right(start, chess_board)
    f_right_row_index = @color == 'white' ? start.row_index - 1 : start.row_index + 1
    f_right_col_index = @color == 'white' ? start.column_index + 1 : start.column_index - 1

    chess_board[f_right_row_index][f_right_col_index] unless invalid_indices?(f_right_row_index, f_right_col_index)
  end

  def valid_target?(start, target, chess_board)
    return true if @moves_made == 0 && opening_double_move?(start, target)

    potential_next_positions = get_direct_adjacents(@relative_move_idxs, start, chess_board)

    potential_next_positions.one? { |position| position == target }
  end
end
