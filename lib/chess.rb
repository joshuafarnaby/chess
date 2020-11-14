# frozen_string_literal: true

require_relative 'board'
require_relative 'convertable'
require_relative './chess_pieces/king'
require_relative './chess_pieces/queen'
require_relative './chess_pieces/rook'
require_relative './chess_pieces/knight'
require_relative './chess_pieces/bishop'
require_relative './chess_pieces/pawn'

class Chess < GameBoard
  include Convertable

  attr_accessor :chess_board, :rounds_played

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

    @rounds_played = 0
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

  def execute_move(starting_square, target_square)
    moving_piece = starting_square.occupying_piece

    starting_square.reset

    if target_square.is_occupied
      captured_piece = target_square.occupying_piece
      captured_piece.in_play = false
      moving_piece.team == 'white' ? @black_graveyard.push(captured_piece) : @white_graveyard.push(captured_piece)
      target_square.occupying_piece = moving_piece
    else
      target_square.occupying_piece = moving_piece
      target_square.is_occupied = true
    end

    moving_piece.moves_made += 1
  end

  def gets_starter_square(current_player)
    puts 'Enter the position of the piece you want to move (e.g. A5):'

    loop do
      start_file_rank = gets_file_rank

      board_indicies = convert_filerank_to_index(start_file_rank)
      starter_square = @chess_board[board_indicies[0]][board_indicies[1]]

      return starter_square if valid_starter_square?(starter_square, current_player)

      puts 'That postion is invalid, choose another:'
    end
  end

  def gets_target_square(current_player, starter_square)
    puts 'Enter the position of the square you want to move to:'

    loop do
      target_file_rank = gets_file_rank

      board_indicies = convert_filerank_to_index(target_file_rank)
      target_square = @chess_board[board_indicies[0]][board_indicies[1]]

      return target_square if valid_target_square?(starter_square, target_square, current_player)

      puts 'That move cannot be executed, choose another position:'
    end
  end

  def valid_starter_square?(board_square, current_player)
    return false if board_square.occupying_piece.nil?
    return false if board_square.occupying_piece.color != current_player
    return false if board_square.occupying_piece.blocked_in?(board_square, @chess_board, current_player)

    true
  end

  def valid_target_square?(starter_square, target_square, current_player)
    moving_piece = starter_square.occupying_piece

    return false if target_square.is_occupied && target_square.occupying_piece.team == current_player
    return false unless moving_piece.move_is_legal?(starter_square, target_square, @chess_board, current_player)

    # return false if moving_piece.path_is_blocked?(starter_square, target_square, @chess_board)

    true
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

  def gets_file_rank
    loop do
      input = gets.chomp.upcase

      return input unless input.match(/[a-hA-H]{1}[1-8]{1}/).nil?

      puts 'That position is invalid, enter another:'
    end
  end
end
