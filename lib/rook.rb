require_relative 'piece'
require_relative 'moveable'
require 'pry-byebug'

# manages the rook piece
class Rook < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♜'
    @black = '♖'
  end

  attr_reader :white, :black, :player

  include Moveable_in_straight_line

  def possible_moves(board)
    exclude_out_of_bounds_moves(valid_horizontal(board) + valid_vertical(board))
  end
end
