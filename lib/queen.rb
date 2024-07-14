require_relative 'piece'
require_relative 'rook'
require_relative 'bishop'
require_relative 'jsonable'

# manages the queen piece
class Queen < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♛'
    @black = '♕'
  end

  include JSONable

  attr_reader :white, :black, :player

  include MoveableDiagonally
  include MoveableInStraightLine

  def possible_moves(board)
    exclude_out_of_bounds_moves(right_diagonal(board) + left_diagonal(board) + valid_horizontal(board) + valid_vertical(board))
  end
end
