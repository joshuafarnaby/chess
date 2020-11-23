# frozen_string_literal: true

module Moveable
  def execute_standard_move(start, target)
    moving_piece = start.reset

    target.occupying_piece = moving_piece
    target.is_occupied = true

    moving_piece.moves_made += 1
  end

  def execute_capture_move(start, target, chess_obj)
    moving_piece = start.reset
    captured_piece = target.reset

    target.occupying_piece = moving_piece
    target.is_occupied = true

    if captured_piece.color == 'white'
      chess_obj.white_graveyard.push(captured_piece)
    else
      chess_obj.black_graveyard.push(captured_piece)
    end

    moving_piece.moves_made += 1
  end

  def execute_opening_double_move(start, target, chess_obj)
    moving_piece = start.reset

    target.occupying_piece = moving_piece
    target.is_occupied = true

    moving_piece.en_passant = chess_obj.round_number
    moving_piece.moves_made += 1
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

  def friendly_fire?(start, target)
    return false unless target.is_occupied

    start_color = start.occupying_piece.color
    target_color = target.occupying_piece.color

    start_color == target_color
  end
end
