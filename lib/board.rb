# frozen_string_literal: true

require 'colorize'
require_relative 'board_square'

class GameBoard
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
