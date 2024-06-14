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
    puts 'What piece would you like to move?'
    piece = player_coordinates
    piece = board.board[piece[0]][piece[1]]

    puts 'Where would you like to move it?'

    loop do
      coordinates = player_coordinates
      next puts 'That move is illegal.' unless valid_input?(piece, coordinates)

      update_board(piece, coordinates[0], coordinates[1])
      return
    end
  end

  def update_board(piece, row, col)
    board.board[row][col] = piece
    board.board[piece.row][piece.col] = nil

    piece.row = row
    piece.col = col

    piece.has_moved = true if piece.instance_of?(Pawn)
  end

  def player_coordinates
    gets.chomp.split(',').map { |num| num.to_i - 1 }
  end

  def valid_input?(piece, coordinates)
    return false unless piece.possible_moves(board.board).include?(coordinates)

    true
  end
end
