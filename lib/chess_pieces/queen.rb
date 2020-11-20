# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/blockable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/convertable.rb'
require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/gettable.rb'

class Queen
  include Blockable
  include Convertable

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
    @symbol = @team == 'white' ? "\u2655" : "\u265B"
    @in_play = true
    @moves_made = 0
  end

  def blocked_in?(start, chess_board)
    blocked?(DIRECT_ADJACENT, start, chess_board)
  end
end
