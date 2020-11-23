# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

class Rook
  include Blockable
  include Pathable
  include Moveable

  attr_reader :name, :color, :symbol
  attr_accessor :moves_made, :in_play

  DIRECT_ADJACENT = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0]
  ].freeze

  def initialize(color)
    @name = 'rook'
    @color = color
    @symbol = @color == 'white' ? "\u2656" : "\u265C"
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

  def blocked_in?(start, chess_board)
    blocked?(DIRECT_ADJACENT, start, chess_board)
  end

  def legal_move?(start, target, chess_board)
    target_position_valid?(start, target) && path_is_clear?(start, target, chess_board)
  end

  private

  def path_is_clear?(start, target, chess_board)
    index_adjustment = determine_direction(start, target)

    path_to_target = build_path(start, target, chess_board, index_adjustment)

    path_to_target.all? { |position| !position.is_occupied }
  end

  def target_position_valid?(start, target)
    same_rank?(start, target) || same_file?(start, target)
  end
end
