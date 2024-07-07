require_relative 'board'
require_relative 'blockable'

class Game
  def initialize
    @board = Board.new
    @white_king = board.board[0][4]
    @black_king = board.board[7][4]
    @turn = 'white'
  end

  attr_reader :board, :white_king, :black_king
  attr_accessor :turn

  include Blockable

  def play
    board.display_board

    loop do
      puts "#{turn.capitalize}'s turn!"

      return puts 'You have agreed to a draw!' if move_piece == 'draw'

      board.display_board

      if white_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, black wins!' if white_check_mate?
      end

      if black_king.in_check?(board.board)
        puts 'check'
        break puts 'Check mate, white wins!' if black_check_mate?
      end

      next_turn
    end
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

    if black_king.possible_moves(board.board).empty?
      return true unless checker_can_be_taken?(checker) || checker_path_can_be_blocked?(checker, black_king)
    end

    false
  end

  def move_piece
    piece = choose_piece

    return piece if piece == 'draw'

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = player_coordinates
      next puts 'That move is illegal.' unless valid_coordinates?(piece, coordinates)

      board_backup = board.board
      update_board(piece, coordinates[0], coordinates[1])

      different_move(board_backup) if still_in_check?

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

  def different_move(board_backup)
    board.board = board_backup
    move_piece
  end

  def choose_piece
    loop do
      puts 'What piece would you like to move?'
      piece = player_coordinates

      return piece.join if piece.join == 'draw'

      piece = board.board[piece[0]][piece[1]]

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

  def player_coordinates
    coordinates = gets.chomp.split(',')

    return coordinates if coordinates.join == 'draw'

    coordinates.map { |num| num.to_i - 1 }
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
