# frozen_string_literal: true

require 'colorize'
require_relative 'board_square'

class GameBoard
  attr_accessor :game_board

  def initialize(columns, rows)
    @columns = columns.to_a
    @rows = rows.to_a.reverse
    @game_board = create_board(@columns, @rows)
  end

  def create_board(columns, rows)
    board = []

    rows.each do |row|
      new_row = []
      columns.each { |column| new_row.push(BoardSquare.new(column, row)) }
      board.push(new_row)
    end

    board
  end
end
