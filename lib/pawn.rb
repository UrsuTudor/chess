require_relative 'piece'
require_relative 'board'

# manages the pawn piece
class Pawn < Piece
  def initialize(player, current_position)
    super(player, current_position)
    @white = '♙'
    @black = '♟︎'
    @has_moved = false
  end

  attr_reader :white, :black, :player, :has_moved, :row, :col

  def valid_one_forward
    if player == 'white'
      valid_moves = [row + 1, col]
    elsif player == 'black'
      valid_moves = [row - 1, col]
    end
  end

  def valid_doulbe_forward
    if player == 'white'
      valid_moves = [row + 2, col]
    elsif player == 'black'
      valid_moves = [row - 2, col]
    end
  end
end
