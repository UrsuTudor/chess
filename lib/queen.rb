# manages the queen piece
class Queen
  def initialize(player)
    @player = player
    @white = '♛'
    @black = '♕'
  end

  attr_reader :white, :black, :player
end
