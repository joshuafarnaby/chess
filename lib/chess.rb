# frozen_string_literal: true

require_relative 'board'
require_relative './chess_pieces/king'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/pawn'

class Chess
  FILE_INDEX_CONVERTER = {
    'A' => 0,
    'B' => 1,
    'C' => 2,
    'D' => 3,
    'E' => 4,
    'F' => 5,
    'G' => 6,
    'H' => 7
  }.freeze

  attr_accessor :chess_board

  def initialize
    @chess_board = initialize_chess_board(GameBoard.new(('A'..'H'), (1..8)))
  end

  private

  def initialize_chess_board(game_board)
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
    add_rooks(rank, color)
    add_knights(rank, color)
    add_bishops(rank, color)
    add_queen_and_king(rank, color)
  end

  def add_rooks(rank, color)
    rank[0].occupying_piece = Rook.new(color)
    rank[0].is_occupied = true

    rank[7].occupying_piece = Rook.new(color)
    rank[7].is_occupied = true
  end

  def add_knights(rank, color)
    rank[1].occupying_piece = Knight.new(color)
    rank[1].is_occupied = true

    rank[6].occupying_piece = Knight.new(color)
    rank[6].is_occupied = true
  end

  def add_bishops(rank, color)
    rank[2].occupying_piece = Bishop.new(color)
    rank[2].is_occupied = true

    rank[5].occupying_piece = Bishop.new(color)
    rank[5].is_occupied = true
  end

  def add_queen_and_king(rank, color)
    rank[3].occupying_piece = Queen.new(color)
    rank[3].is_occupied = true

    rank[4].occupying_piece = King.new(color)
    rank[4].is_occupied = true
  end
end
