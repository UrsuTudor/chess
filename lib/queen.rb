require_relative 'piece'

# manages the queen piece
class Queen < Piece
  def initialize(player, row, col)
    super(player, row, col)
    @white = '♛'
    @black = '♕'
  end

  attr_reader :white, :black, :player
end
