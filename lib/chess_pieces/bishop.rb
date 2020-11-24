# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

class Bishop
  include Pathable
  include Moveable

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

  def execute_move(start, target, chess_obj)
    if !target.is_occupied
      execute_standard_move(start, target)
    elsif target.is_occupied
      execute_capture_move(start, target, chess_obj)
    end
  end

  def legal_move?(start, target, chess_obj)
    chess_board = chess_obj.chess_board

    target_position_valid?(start, target) && path_is_clear?(start, target, chess_board)
  end

  private

  def path_is_clear?(start, target, chess_board)
    index_adjustment = evaluate_diagonal_path(start, target)

    path_to_target = build_path(start, target, chess_board, index_adjustment)

    path_to_target.all? { |position| !position.is_occupied }
  end

  def target_position_valid?(start, target)
    diagonally?(start, target)
  end
end
