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
    @graveyard = []
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

  def take_turn(current_player)
    square_with_piece_to_move = get_square_with_piece_to_move(current_player)

    target_square = get_target_square(square_with_piece_to_move, current_player)
  end

  def get_square_with_piece_to_move(current_player)
    puts 'Enter the position of the piece you want to move (e.g. A5):'
    loop do
      input = gets.chomp.upcase
      if !input.match(/[a-hA-H]{1}[1-8]{1}/).nil?
        pos_index = convert_filerank_to_index(input)
        board_square = @chess_board[pos_index[0]][pos_index[1]]
        if board_square.occupying_piece.nil?
          puts 'That position is empty, please choose another:'
          next
        elsif board_square.occupying_piece.team != current_player
          puts 'The piece on that square belongs to the opposition, please choose another:'
          next
        elsif @rounds_played < 2 && board_square.occupying_piece.name != 'pawn'
          puts 'You must move a pawn for your first go'
        else
          return board_square
        end
      else
        puts 'That position is invalid, please choose another:'
        next
      end
    end
  end

  def get_target_square(starting_square, current_player)
    puts 'Now enter the position you want to move to:'
    loop do
      input = gets.chomp.upcase
      if !input.match(/[a-hA-H]{1}[1-8]{1}/).nil?
        pos_index = convert_filerank_to_index(input)
        target_square = @chess_board[pos_index[0]][pos_index[1]]
        if move_is_legal?(starting_square, target_square, current_player) && path_is_clear?(starting_square, target_square)
          return target_square
        else
          puts 'That move cannot be made, please choose another position:'
        end
      else
        puts 'That position is invalid, please choose another:'
        next
      end
    end
  end

  def move_is_legal?(starting_square, target_square, current_player)
    moving_piece = starting_square.occupying_piece

    execute_move(starting_square, target_square) if moving_piece.can_make_move?(starting_square, target_square, current_player)
  end

  def path_is_clear?(_start_pos, _end_pos)
    true
  end

  def execute_move(starting_square, target_square)
    moving_piece = starting_square.occupying_piece

    starting_square.occupying_piece = nil
    starting_square.is_occupied = false

    if target_square.is_occupied
      @graveyard.push(target_square.occupying_piece)
      target_square.occupying_piece = moving_piece
    else
      target_square.occupying_piece = moving_piece
      target_square.is_occupied = true
    end
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
