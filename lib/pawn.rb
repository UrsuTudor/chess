require_relative 'piece'
require_relative 'board'

# manages the pawn piece
class Pawn < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♙'
    @black = '♟︎'
    @has_moved = false
  end

  attr_reader :white, :black, :player, :has_moved, :row, :col

  def valid_one_forward
    if player == 'white'
      [row + 1, col]
    elsif player == 'black'
      [row - 1, col]
    end
  end

  def valid_doulbe_forward
    if player == 'white'
      [row + 2, col]
    elsif player == 'black'
      [row - 2, col]
    end
  end

  def valid_white_takes(board)
    valid_takes = []

    valid_takes.push([row + 1, col + 1]) if opponent_piece?(board, row + 1, col + 1)

    valid_takes.push([row + 1, col - 1]) if opponent_piece?(board, row + 1, col - 1)

    valid_takes
  end

  def valid_black_takes(board)
    valid_takes = []

    valid_takes.push([row - 1, col + 1]) if opponent_piece?(board, row - 1, col + 1)

    valid_takes.push([row - 1, col - 1]) if opponent_piece?(board, row - 1, col - 1)

    valid_takes
  end
end
