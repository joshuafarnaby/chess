# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/pathable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/moveable.rb'

class Queen
  include Blockable
  include Pathable
  include Moveable

  attr_reader :name, :color, :symbol
  attr_accessor :in_play, :moves_made

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
    @name = 'queen'
    @color = color
    @symbol = @color == 'white' ? "\u2655" : "\u265B"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(start, chess_board)
    blocked?(DIRECT_ADJACENT, start, chess_board)
  end

  def execute_move(start, target, chess_obj)
    if !target.is_occupied
      execute_standard_move(start, target)
    elsif target.is_occupied
      execute_capture_move(start, target, chess_obj)
    end
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
    same_rank?(start, target) || same_file?(start, target) || diagonally?(start, target)
  end
end
