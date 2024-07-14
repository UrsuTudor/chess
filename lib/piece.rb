require 'pry-byebug'

# initializes player, row and col
# contains methods that determine whether or not a given piece is an opponent or an ally of self, and whether or not a
# desired move would be out of bounds
class Piece
  def initialize(player, row, col)
    @player = player
    @row = row
    @col = col
  end
  attr_reader :player
  attr_accessor :row, :col

  def opponent_piece?(board, row, col)
    return false if board[row][col].nil?

    return false if player == 'white' && board[row][col].player == 'white'

    return false if player == 'black' && board[row][col].player == 'black'

    true
  end

  def allied_piece?(board, row, col)
    return false if board[row][col].nil?

    return true if player == 'white' && board[row][col].player == 'white'

    return true if player == 'black' && board[row][col].player == 'black'

    false
  end

  def exclude_out_of_bounds_moves(possible_moves)
    possible_moves.delete_if { |el| el.nil? || el[0] > 7 || el[0].negative? || el[1] > 7 || el[1].negative? }
  end
end
