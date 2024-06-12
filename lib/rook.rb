require_relative 'piece'

# manages the rook piece
class Rook < Piece
  def initialize(player, current_position)
    super(player, current_position)
    @white = '♜'
    @black = '♖'
  end

  attr_reader :white, :black, :player
end
