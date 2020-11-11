# frozen_string_literal: true

require 'colorize'
require_relative 'board_square'

# king = "\u265A"

# puts "8|\u265C|\u265E|\u265C|\u265B|\u265A|\u265C|\u265E|\u265C|"
# puts "7|\u265F|\u265F|\u265F|\u265F|\u265F|\u265F|\u265F|\u265F|"
# puts '6| | | | | | | | |'
# puts '5| | | | | | | | |'
# puts '4| | | | | | | | |'
# puts '3| | | | | | | | |'
# puts "2|\u2659|\u2659|\u2659|\u2659|\u2659|\u2659|\u2659|\u2659|"
# puts "1|\u2656|\u2658|\u2657|\u2655|\u2654|\u2657|\u2658|\u2656|"
# puts '  A B C D E F G H'

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

  def display_board
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

# g = GameBoard.new(('A'..'H'), (1..8))
# g.display_board
