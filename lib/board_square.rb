# frozen_string_literal: true

require '/Users/joshuafarnaby/Ruby/final_project/chess/lib/modules/convertable.rb'

class BoardSquare
  include Convertable

  attr_reader :position, :row_index, :column_index
  attr_accessor :is_occupied, :occupying_piece

  def initialize(file, rank)
    @position = "#{file}#{rank}"
    @occupying_piece = nil
    @is_occupied = false
    @row_index = gets_row_index(@position)
    @column_index = gets_column_index(@position)
  end

  def reset
    moving_piece = @occupying_piece

    @occupying_piece = nil
    @is_occupied = false

    moving_piece
  end
end
