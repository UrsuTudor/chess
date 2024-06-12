# manages the pawn piece
class Pawn
  def initialize(player)
    @player = player
    @white = '♙'
    @black = '♟︎'
  end

  attr_reader :white, :black, :player
end
