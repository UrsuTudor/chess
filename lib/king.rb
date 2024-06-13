require_relative 'piece'

# manages the king piece
class King < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♚'
    @black = '♔'
  end

  attr_reader :white, :black, :player
end
