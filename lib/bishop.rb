require_relative 'piece'
require_relative 'moveable'
require_relative 'jsonable'

# tracks player, position and contains the methods that make it possible to move the bishop legally
class Bishop < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♝'
    @black = '♗'
  end

  include MoveableDiagonally
  include JSONable

  attr_reader :white, :black, :player

  def possible_moves(board)
    exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board))
  end
end
