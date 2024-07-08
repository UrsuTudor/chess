require_relative 'piece'
require_relative 'jsonable'

# manages the knight piece
class Knight < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♞'
    @black = '♘'
  end

  include JSONable

  attr_reader :white, :black, :player

  def possible_moves(board)
    knight_moves = upward_moves + downward_moves

    in_bounds_moves = exclude_out_of_bounds_moves(knight_moves)

    filtered_allies = in_bounds_moves.delete_if { |move| allied_piece?(board, move[0], move[1]) }
    filtered_allies.delete_if { |square| board[square[0]][square[1]].instance_of?(King) }
  end

  def upward_moves
    [[row + 1, col + 2], [row + 2, col + 1], [row + 1, col - 2], [row + 2, col - 1]]
  end

  def downward_moves
    [[row - 1, col + 2], [row - 2, col + 1], [row - 1, col - 2], [row - 2, col - 1]]
  end
end
