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

  def initialize(files, ranks)
    @files = files.to_a
    @ranks = ranks.to_a.reverse
    @game_board = create_board(@files, @ranks)
  end

  def create_board(files, ranks)
    board = []

    ranks.each do |rank|
      row = []
      files.each { |file| row.push(BoardSquare.new(file, rank)) }
      board.push(row)
    end

    board
  end

  def display_board
    @game_board.each_with_index do |rank, idx|
      output = "#{@game_board.length - idx}|"

      rank.each do |board_square|
        output += board_square.is_occupied ? "#{board_square.occupying_piece}|" : ' |'
      end

      puts output
    end

    puts "  #{@files.join(' ')}"
  end
end

g = GameBoard.new(('A'..'H'), (1..8))
g.display_board

# g.game_board[0][0].occupying_piece = "\u265A"
# g.game_board[0][0].is_occupied = true

# g.game_board.each_with_index do |rank, idx|
#   num = g.game_board.length - idx
#   output = "#{num}|"
#   rank.each do |board_square|
#     output += if !board_square.is_occupied
#                 ' |'
#               else
#                 "#{board_square.occupying_piece}|"
#               end
#   end

#   puts output
# end
