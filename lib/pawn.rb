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

  attr_reader :white, :black, :player, :has_moved

  def valid_one_forward
    if player == 'white'
      valid_moves = [current_position[0] + 1, current_position[1]]
    elsif player == 'black'
      valid_moves = [current_position[0] - 1, current_position[1]]
    end
  end

  def valid_doulbe_forward
    if player == 'white'
      valid_moves = [current_position[0] + 2, current_position[1]]
    elsif player == 'black'
      valid_moves = [current_position[0] - 2, current_position[1]]
    end
  end
end
