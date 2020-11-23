# frozen_string_literal: true

require_relative 'board'
require_relative './modules/convertable'
require_relative './chess_pieces/king'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/pawn'

class Chess < GameBoard
  include Convertable

  attr_accessor :chess_board, :round_number, :white_graveyard, :black_graveyard

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

    @round_number = 0
    @white_graveyard = []
    @black_graveyard = []
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

  def take_turn(current_color)
    @round_number += 1

    begin_turn_prompt(current_color)

    positions = gets_positions(current_color)

    start = positions[0]
    target = positions[1]

    moving_piece = start.occupying_piece

    moving_piece.execute_move(start, target, self)
  end

  private

  def gets_positions(color)
    loop do
      positions = gets_player_input.split('/')

      start = get_corresponding_square(positions[0])
      target = get_corresponding_square(positions[1])

      return [start, target] if valid_move?(start, target, color)

      puts 'That move is not legal, make another move:'
    end
  end

  def valid_move?(start, target, color)
    if valid_start?(start, color)
      moving_piece = start.occupying_piece
      moving_piece.legal_move?(start, target, self)
    else
      # puts issue(start, color)
      false
    end
  end

  def valid_start?(start, color)
    start.is_occupied && start.occupying_piece.color == color
  end

  # def issue(start, color)
  #   position = start.position
  #   piece = start.occupying_piece.name if start.is_occupied

  #   puts "#{position} is empty, make a different move:" unless start.is_occupied

  #   if start.is_occupied && start.occupying_piece.color != color
  #     puts "The #{piece} at #{position} belongs to the opposition, make a different move:"
  #   end
  # end

  def begin_turn_prompt(color)
    puts "#{color.capitalize}, make your move:"
    puts 'E.G: To move from A2 to A4 enter A2/A4'
  end

  def gets_player_input
    loop do
      input = gets.chomp.upcase

      return input unless input.match(%r{^[A-H]{1}[1-8]{1}/[A-H]{1}[1-8]{1}$}i).nil?

      puts 'That input is not recognised, try again:'
    end
  end

  def get_corresponding_square(filerank_str)
    row_index = gets_row_index(filerank_str)
    column_index = gets_column_index(filerank_str)

    @chess_board[row_index][column_index]
  end

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
