# manages the bishop piece
class Bishop
  def initialize(player)
    @player = player
    @white = '♝'
    @black = '♗'
  end

  attr_reader :white, :black, :player
end
