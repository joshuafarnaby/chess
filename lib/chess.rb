# frozen_string_literal: true

require_relative 'board'
require_relative 'king'
require_relative 'queen'
require_relative 'rook'
require_relative 'knight'
require_relative 'bishop'
require_relative 'pawn'

class Chess
  # attr_accessor :chess_board

  def initialize
    @chess_board = populate_board_start(GameBoard.new(('A'..'H'), (1..8)))
  end

  def populate_board_start(game_board)
    add_back_row(game_board.game_board[7], 'white')
    add_pawns(game_board.game_board[6], 'white')

    add_back_row(game_board.game_board[0], 'black')
    add_pawns(game_board.game_board[1], 'black')

    game_board
  end

  def add_pawns(rank, color)
    rank.each do |square|
      square.occupying_piece = Pawn.new(color)
      square.is_occupied = true
    end
  end

  def add_back_row(rank, color)
    rank.each_with_index do |square, idx|
      if idx == 0 || idx == 7
        square.occupying_piece = Rook.new(color)
        square.is_occupied = true
        next
      elsif idx == 1 || idx == 6
        square.occupying_piece = Knight.new(color)
        square.is_occupied = true
        next
      elsif idx == 2 || idx == 5
        square.occupying_piece = Bishop.new(color)
        square.is_occupied = true
        next
      elsif idx == 3
        square.occupying_piece = Queen.new(color)
        square.is_occupied = true
      elsif idx == 4
        square.occupying_piece = King.new(color)
        square.is_occupied = true
      end
    end
  end

  def display_chess_board
    @chess_board.display_board
  end
end

c = Chess.new

c.display_chess_board
