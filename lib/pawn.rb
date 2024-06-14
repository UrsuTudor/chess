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

  def valid_one_forward_white(board)
    [row + 1, col] unless allied_piece?(board, row + 1, col)
  end

  def valid_one_forward_black(board)
    [row - 1, col] unless allied_piece?(board, row - 1, col)
  end

  def valid_doulbe_forward_white(board)
    [row + 2, col] unless allied_piece?(board, row + 2, col) || allied_piece?(board, row + 1, col)
  end

  def valid_doulbe_forward_black(board)
    [row - 2, col] unless allied_piece?(board, row - 2, col) || allied_piece?(board, row - 1, col)
  end

  def valid_takes_white(board)
    valid_takes = []

    valid_takes.push([row + 1, col + 1]) if opponent_piece?(board, row + 1, col + 1)

    valid_takes.push([row + 1, col - 1]) if opponent_piece?(board, row + 1, col - 1)

    valid_takes
  end

  def valid_takes_black(board)
    valid_takes = []

    valid_takes.push([row - 1, col + 1]) if opponent_piece?(board, row - 1, col + 1)

    valid_takes.push([row - 1, col - 1]) if opponent_piece?(board, row - 1, col - 1)

    valid_takes
  end
end
