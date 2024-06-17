require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  attr_reader :board

  def play
    board.display_board
    loop do
      move_piece
      board.display_board
    end
  end

  def move_piece
    piece = choose_piece

    puts 'Where would you like to move the piece?'

    loop do
      coordinates = player_coordinates
      next puts 'That move is illegal.' unless valid_input?(piece, coordinates)

      update_board(piece, coordinates[0], coordinates[1])
      return
    end
  end

  def choose_piece
    loop do
      puts 'What piece would you like to move?'
      piece = player_coordinates
      piece = board.board[piece[0]][piece[1]]

      next puts 'That spot is empty!' if piece.nil?
      next puts 'That piece cannot move at the moment!' if piece.possible_moves(board.board).empty?

      return piece
    end
  end

  def update_board(piece, row, col)
    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    return unless piece.instance_of?(Pawn)

    piece.has_moved = true
    # having them like this is not a problem because a white pawn will never get to row 7 and a black pawn will never
    # get to row 0, so the methods will simply return if the pawn does not belong to the specified player
    piece.promote_pawn_black(board.board)
    piece.promote_pawn_white(board.board)
  end

  def player_coordinates
    gets.chomp.split(',').map { |num| num.to_i - 1 }
  end

  def valid_input?(piece, coordinates)
    return false unless piece.possible_moves(board.board).include?(coordinates)

    true
  end
end
