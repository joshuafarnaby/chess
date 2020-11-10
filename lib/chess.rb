# frozen_string_literal: true

require_relative 'board'

class Chess
  # attr_accessor :chess_board

  def initialize
    @chess_board = GameBoard.new(('A'..'H'), (1..8))
  end

  def display_chess_board
    @chess_board.display_board
  end
end

c = Chess.new

c.chess_board
