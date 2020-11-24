# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

class King
  include Pathable
  include Moveable

  attr_accessor :in_play, :moves_made
  attr_reader :name, :color, :symbol

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
    @name = 'king'
    @color = color
    @symbol = @color == 'white' ? "\u2654" : "\u265A"
    @in_play = true
    @moves_made = 0
  end

  def execute_move(start, target, chess_obj)
    if !target.is_occupied
      execute_standard_move(start, target)
    elsif target.is_occupied
      execute_capture_move(start, target, chess_obj)
    end
  end

  def legal_move?(start, target, chess_obj)
    chess_board = chess_obj.chess_board

    target_position_valid?(start, target, chess_board) && safe_to_move?(start, target, chess_board)
  end

  private

  def target_position_valid?(start, target, chess_board)
    color = start.occupying_piece.color
    adjacent_positions = get_direct_adjacents(DIRECT_ADJACENT, start, chess_board)

    adjacent_positions.one? do |position|
      position == target && (!position.is_occupied || position.is_occupied && position.occupying_piece.color != color)
    end
  end

  def safe_to_move?(_start, _target, _chess_board)
    true
  end
end
