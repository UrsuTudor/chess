require_relative 'lib/game'

game = Game.new
game.play

# go through the code and optimize it
# don't let the player move a piece if that move would make their king be in a check
