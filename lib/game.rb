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
    piece = gets.chomp.split(',').map { |num| num.to_i - 1 }

    puts 'Where would you like to move it?'

    loop do
      coordinates = gets.chomp.split(',').map { |num| num.to_i - 1 }
      next 'That move is illegal.' unless board.board[piece[0]][piece[1]].possible_moves(board.board).includes?(coordinates)

      board.board[coordinates[0]][coordinates[1]] = board.board[piece[0]][piece[1]]
      board.board[piece[0]][piece[1]] = nil
      return
    end
  end
end
