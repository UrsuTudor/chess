require_relative 'piece'

# manages the bishop piece
class Bishop < Piece
  def initialize(player, current_position)
    super(player, current_position)
    @white = '♝'
    @black = '♗'
  end

  attr_reader :white, :black, :player
end
