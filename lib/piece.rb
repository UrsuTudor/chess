class Piece
  def initialize(player, current_position)
    @player = player
    @current_position = current_position
    @row = current_position[0]
    @col = current_position[1]
  end
  attr_reader :player, :current_position
end
