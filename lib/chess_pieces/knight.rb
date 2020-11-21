# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/pathable.rb'

class Knight
  include Blockable
  include Pathable

  attr_reader :name, :color, :symbol
  attr_accessor :in_play, :moves_made

  MOVE_LIST = [
    [-2, 1],
    [-1, 2],
    [1, 2],
    [2, 1],
    [2, -1],
    [1, -2],
    [-1, -2],
    [-2, -1]
  ].freeze

  def initialize(color)
    @name = 'knight'
    @color = color
    @symbol = @color == 'white' ? "\u2658" : "\u265E"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(start, chess_board)
    blocked?(MOVE_LIST, start, chess_board)
  end

  def legal_move?(start, target, chess_board)
    target_position_valid?(start, target, chess_board)
  end

  private

  def target_position_valid?(start, target, chess_board)
    color = start.occupying_piece.color
    reachable_positions = get_direct_adjacents(MOVE_LIST, start, chess_board)

    reachable_positions.one? do |position|
      position == target && (!position.is_occupied || position.is_occupied && position.occupying_piece.color != color)
    end
  end
end
