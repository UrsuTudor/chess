require_relative 'piece'

# manages the king piece
class King < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♚'
    @black = '♔'
  end

  attr_reader :white, :black, :player

  def possible_moves(board)
    king_moves = moves_on_lower_row + moves_on_same_row + moves_on_upper_row

    in_bounds_moves = exclude_out_of_bounds_moves(king_moves)

    in_bounds_moves.delete_if { |move| allied_piece?(board, move[0], move[1]) }
  end

  def moves_on_upper_row
    [[row + 1, col - 1], [row + 1, col], [row + 1, col + 1]]
  end

  def moves_on_same_row
    [[row, col - 1], [row, col + 1]]
  end

  def moves_on_lower_row
    [[row - 1, col - 1], [row - 1, col], [row - 1, col + 1]]
  end
end
