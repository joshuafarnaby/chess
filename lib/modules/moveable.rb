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
end
