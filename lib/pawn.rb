require_relative 'piece'
require_relative 'board'
require 'pry-byebug'

# manages the pawn piece
class Pawn < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♙'
    @black = '♟︎'
    @has_moved = false
  end

  attr_reader :white, :black, :player, :row, :col
  attr_accessor :has_moved

  def possible_moves(board)
    possible_moves = []

    if player == 'white'
      possible_moves.push(valid_one_forward_white(board))
      possible_moves.push(valid_doulbe_forward_white(board)) if has_moved == false
      valid_takes_white(board).each { |el| possible_moves.push(el) }
    else
      possible_moves.push(valid_one_forward_black(board))
      possible_moves.push(valid_doulbe_forward_black(board)) if has_moved == false
      valid_takes_black(board).each { |el| possible_moves.push(el) }
    end

    exclude_out_of_bounds_moves(possible_moves)
  end

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

# move the piece
# let pawn transform
