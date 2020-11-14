# frozen_string_literal: true

class BoardSquare
  attr_accessor :is_occupied, :occupying_piece, :position

  def initialize(file, rank)
    @position = "#{file}#{rank}"
    @occupying_piece = nil
    @is_occupied = false
  end

  def reset
    @occupying_piece = nil
    @is_occupied = false
  end
end
