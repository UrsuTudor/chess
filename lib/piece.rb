class Piece
  def initialize(player, current_position)
    @player = player
    @current_position = current_position
  end
  attr_reader :player, :current_position
end
