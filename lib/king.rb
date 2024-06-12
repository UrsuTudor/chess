# manages the king piece
class King
  def initialize(player)
    @player = player
    @white = '♚'
    @black = '♔'
  end

  attr_reader :white, :black, :player
end
