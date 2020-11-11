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

  def display_in_terminal
    @game_board.each_with_index do |row, idx|
      output = "#{@game_board.length - idx}|"

      row.each do |board_square|
        output += board_square.is_occupied ? "#{board_square.occupying_piece.symbol}|" : ' |'
      end

      puts output
    end

    puts "  #{@columns.join(' ')}"
  end
end
