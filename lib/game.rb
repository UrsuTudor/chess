require_relative 'board'

class Game
  def initialize
    @board = Board.new
  end

  attr_reader :board
end
