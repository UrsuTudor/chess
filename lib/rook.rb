require_relative 'piece'
require 'pry-byebug'

# manages the rook piece
class Rook < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♜'
    @black = '♖'
  end

  attr_reader :white, :black, :player

  def valid_horizontal(board)
    exclude_out_of_bounds_moves(left_horizontal(board) + right_horizontal(board))
  end

  def right_horizontal(board)
    right_horizontal = []
    col_of_space = col

    board[row][col + 1..].each do |space|
      # if the space is nil, we can't invoke space.col, so we need to add up the col_of_space to get the proper col
      next right_horizontal.push([row, col_of_space += 1]) if space.nil?

      # here we could add up col_of_space again, which would be slightly more efficient, but it makes the reading more
      # difficult
      break if allied_piece?(board, row, space.col)

      break right_horizontal.push([row, space.col]) if opponent_piece?(board, row, space.col)
    end

    right_horizontal
  end

  def left_horizontal(board)
    left_horizontal = []
    col_of_space = col

    board[row][0...col].reverse.each do |space|
      next left_horizontal.push([row, col_of_space -= 1]) if space.nil?

      break if allied_piece?(board, row, space.col)

      break left_horizontal.push([row, space.col]) if opponent_piece?(board, row, space.col)
    end

    left_horizontal
  end
end
