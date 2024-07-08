require_relative 'piece'
require_relative 'moveable'
require_relative 'jsonable'

# manages the bishop piece
class Bishop < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♝'
    @black = '♗'
  end

  include Moveable_diagonally
  include JSONable

  attr_reader :white, :black, :player

  def possible_moves(board)
    exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board))
  end
end
