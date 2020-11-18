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

  def take_turn(current_color)
    puts begin_turn_prompt(current_color)

    positions = gets_positions(current_color)

    execute_move(positions[0], positions[1])
  end

  private

  def gets_positions(color)
    loop do
      positions = gets_player_input.split('/')

      start = get_corresponding_square(positions[0])
      target = get_corresponding_square(positions[1])

      return [start, target] if valid_start_position?(start, color) && valid_target_position?(start, target)
    end
  end

  def begin_turn_prompt(color)
    "#{color.capitalize}, enter the position of the piece you want to move and the position you want to move to, seperated by a slash (e.g. A2/A4):"
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

  def execute_move(starting_square, target_square)
    moving_piece = starting_square.occupying_piece

    starting_square.reset

    if target_square.is_occupied
      captured_piece = target_square.occupying_piece
      captured_piece.in_play = false
      moving_piece.color == 'white' ? @black_graveyard.push(captured_piece) : @white_graveyard.push(captured_piece)
      target_square.occupying_piece = moving_piece
    else
      target_square.occupying_piece = moving_piece
      target_square.is_occupied = true
    end

    moving_piece.moves_made += 1
  end

  def valid_start_position?(board_square, color)
    if !board_square.is_occupied
      puts 'That position is empty, choose another:'
      return false
    elsif board_square.occupying_piece.color != color
      puts "That #{board_square.occupying_piece.name} belongs to the opposition, choose another:"
      return false
    elsif board_square.occupying_piece.blocked_in?(board_square, @chess_board)
      puts "The #{board_square.occupying_piece.name} at that position is currently blocked, choose another:"
      return false
    end

    true
  end

  def valid_target_position?(start_square, target_square)
    current_color = start_square.occupying_piece.color

    if start_square.position == target_square.position
      puts 'You must move to a different position, choose another:'
      return false
    elsif target_square.is_occupied && target_square.occupying_piece.color == current_color
      puts 'You cannot move to a position occupied by your own color, choose another:'
      return false
    elsif !start_square.occupying_piece.legal_move?(start_square, target_square, @chess_board)
      puts "A #{start_square.occupying_piece.name} cannot legally move to that position, choose another"
      return false
    end

    true
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
