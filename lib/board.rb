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
  def initialize(files, ranks)
    @files = files.to_a
    @ranks = ranks.to_a.reverse
    @game_board = create_board(@files, @ranks)
  end

  def create_board(files, ranks); end
end
