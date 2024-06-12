# manages the knight piece
class Knight
  def initialize(player)
    @player = player
    @white = '♞'
    @black = '♘'
  end

  attr_reader :white, :black, :player
end
