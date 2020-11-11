# frozen_string_literal: true

require_relative 'board'
require_relative 'pawn'

class Chess
  # attr_accessor :chess_board

  def initialize
    @chess_board = populate_board_start(GameBoard.new(('A'..'H'), (1..8)))
  end

  def populate_board_start(game_board)
    add_pawns(game_board.game_board[6], 'white')
    add_pawns(game_board.game_board[1], 'black')

    game_board
  end

  def add_pawns(rank, color)
    rank.each do |square|
      square.occupying_piece = Pawn.new(color)
      square.is_occupied = true
    end
  end

  def display_chess_board
    @chess_board.display_board
  end
end

c = Chess.new

c.display_chess_board
