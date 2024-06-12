# manages the rook piece
class Rook
  def initialize(player)
    @player = player
    @white = '♜'
    @black = '♖'
  end

  attr_reader :white, :black, :player
end
