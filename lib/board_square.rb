# frozen_string_literal: true

class BoardSquare
  attr_accessor :is_occupied, :occupying_piece

  def initialize(file, rank)
    @file = file
    @rank = rank
    @position = [@file, @rank]
    # @index = [@file - 1, @rank - 1]
    @is_occupied = false
    @occupying_piece = nil
  end
end
