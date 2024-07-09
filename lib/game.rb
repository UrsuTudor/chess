require_relative 'board'
require_relative 'blockable'
require_relative 'jsonable'
require_relative 'saveable'
require 'json'
require 'erb'

class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
    @turn = 'white'
  end

  attr_accessor :turn, :board, :white_king, :black_king

  include Blockable
  include JSONable
  include Saveable

  def play
    board.display_board

    puts "\nYou can ask for a draw, save or to load your latest save
by typing the word in the console at any point."

    loop do
      puts "\n#{turn.capitalize}'s turn!"
      puts "\nWhat piece would you like to move?"
      player_action = player_input

      break puts "\nYou have agreed to a draw!" if player_action == 'draw'
      next if save_or_load?(player_action)

      move_piece(player_action)
      board.display_board

      break if check_mate?
      check?

      next_turn
    end
  end

  def check?
    if white_king.in_check?(board.board)
      puts "\nCheck!"
    elsif black_king.in_check?(board.board)
      puts "\nCheck!"
    end
  end

  def check_mate?
    if white_check_mate?
      puts "\nCheck mate, black wins!"
      return true
    elsif black_check_mate?
      puts "\nCheck mate, white wins!"
      return true
    end

    false
  end

  def checker_can_be_taken?(checker)
    simulated_king = King.new(checker.player, checker.row, checker.col)

    return true if simulated_king.in_check?(board.board) || simulated_king.check_from_king?(board.board)

    false
  end

  def white_check_mate?
    checker = white_king.in_check?(board.board)

    if white_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, white_king)
    end

    false
  end

  def black_check_mate?
    checker = black_king.in_check?(board.board)
    return if checker == false

    if black_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, black_king)
    end

    false
  end

  def move_piece(input)
    piece = choose_piece(input)
    row_backup = piece.row
    col_backup = piece.col

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = player_input
      next puts 'That move is illegal.' unless valid_coordinates?(piece, coordinates)

      update_board(piece, coordinates[0], coordinates[1])

      different_move(piece, row_backup, col_backup, coordinates) if still_in_check?
      break
    end
  end

  def still_in_check?
    if turn == 'white' && white_king.in_check?(board.board) || turn == 'black' && black_king.in_check?(board.board)
      puts 'That move leaves your king in check!'
      return true
    end

    false
  end

  def different_move(old_piece, row_backup, col_backup, old_coordinates)
    old_piece.row = row_backup
    old_piece.col = col_backup

    board.board[row_backup][col_backup] = old_piece
    board.board[old_coordinates[0]][old_coordinates[1]] = nil

    puts 'Select the same piece with a different move or a different piece, please!'

    new_input = player_input
    move_piece(new_input)
  end

  def choose_piece(input)
    loop do
      piece = board.board[input[0]][input[1]]

      if valid_piece?(piece)
        piece
      else
        new_input = player_input
        piece = board.board[new_input[0]][new_input[1]]
      end

      next unless valid_piece?(piece)

      return piece
    end
  end

  def update_board(piece, row, col)
    # set handle king to only move the rook and let the regular update board function move the king
    handle_king(piece, row, col) if piece.instance_of?(King)

    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    handle_pawn(piece) if piece.instance_of?(Pawn)
  end

  def handle_pawn(pawn)
    pawn.has_moved = true
    # having them like this is not a problem because a white pawn will never get to row 7 and a black pawn will never
    # get to row 0, so the methods will simply return if the pawn does not belong to the specified player
    pawn.promote_pawn_black(board.board)
    pawn.promote_pawn_white(board.board)
  end

  def handle_king(king, row, col)
    return if king.has_moved == true

    do_castle_right(board.board, row, col) if king.castle_right?(board.board)
    do_castle_left(board.board, row, col) if king.castle_left?(board.board)

    king.has_moved = true
  end

  def do_castle_right(board, row, col)
    return unless row == 7 && col == 6 || row.zero? && col == 6

    board[row][5] = Rook.new(board[row][7].player, row, 7)
    board[row][7] = nil
  end

  def do_castle_left(board, row, col)
    return unless row == 7 && col == 2 || row.zero? && col == 2

    board[row][3] = Rook.new(board[row][0].player, row, 3)
    board[row][0] = nil
  end

  def player_input
    input = gets.chomp.split(',')

    input = input.join.downcase if input.length == 1

    if input =='draw' || input == 'save' || input == 'load'
      input
    elsif input.length == 2
      input.map { |num| num.to_i - 1 }
    else
      puts "Appropriate input is 'draw', 'save', 'load' or coordinates in this format: x,y"
      player_input
    end
  end

  def valid_coordinates?(piece, coordinates)
    return false unless piece.possible_moves(board.board).include?(coordinates)

    true
  end

  def valid_piece?(piece)
    if piece.nil?
      puts 'That spot is empty!'
      return false
    elsif piece.possible_moves(board.board).empty?
      puts 'That piece cannot move at the moment!'
      return false
    elsif piece.player != turn
      puts 'That piece does not belong to you!'
      return false
    end

    true
  end

  def next_turn
    self.turn = if turn == 'white'
                  'black'
                else
                  'white'
                end
  end
end
