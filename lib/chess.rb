# frozen_string_literal: true

require_relative 'board'
require_relative './chess_pieces/king'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/pawn'

class Chess < GameBoard
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
    @white_pieces = [
      [Rook.new('white'), Knight.new('white'), Bishop.new('white'), Queen.new('white'), King.new('white'), Bishop.new('white'), Knight.new('white'), Rook.new('white')],
      [Pawn.new('white'), Pawn.new('white'), Pawn.new('white'), Pawn.new('white'), Pawn.new('white'), Pawn.new('white'), Pawn.new('white'), Pawn.new('white')]
    ]

    @black_pieces = [
      [Rook.new('black'), Knight.new('black'), Bishop.new('black'), Queen.new('black'), King.new('black'), Bishop.new('black'), Knight.new('black'), Rook.new('black')],
      [Pawn.new('black'), Pawn.new('black'), Pawn.new('black'), Pawn.new('black'), Pawn.new('black'), Pawn.new('black'), Pawn.new('black'), Pawn.new('black')]
    ]

    @files = %w[A B C D E F G H]
    @ranks = [8, 7, 6, 5, 4, 3, 2, 1]
    @chess_board = initialize_chess_board
  end

  def display_in_terminal
    @chess_board.each_with_index do |row, idx|
      output = "#{@chess_board.length - idx}|"

      row.each do |board_square|
        output += board_square.is_occupied ? "#{board_square.occupying_piece.symbol}|" : ' |'
      end

      puts output
    end

    puts "  #{@files.join(' ')}"
  end

  private

  def initialize_chess_board
    chess_board = create_board(@files, @ranks)

    add_white_pieces_to_board(chess_board)
    add_black_pieces_to_board(chess_board)

    chess_board
  end

  def add_white_pieces_to_board(chess_board)
    chess_board[7].each_with_index do |square, idx|
      square.occupying_piece = @white_pieces[0][idx]
      square.is_occupied = true
    end

    chess_board[6].each_with_index do |square, idx|
      square.occupying_piece = @white_pieces[1][idx]
      square.is_occupied = true
    end
  end

  def add_black_pieces_to_board(chess_board)
    chess_board[0].each_with_index do |square, idx|
      square.occupying_piece = @black_pieces[0][idx]
      square.is_occupied = true
    end

    chess_board[1].each_with_index do |square, idx|
      square.occupying_piece = @black_pieces[1][idx]
      square.is_occupied = true
    end
  end
end
