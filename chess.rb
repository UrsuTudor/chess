require_relative 'lib/game'

game = Game.new
game.play

# fix the scenario in which the king is not in chess, but would be in chess if the player moves the piece that is currently
# protecting the piece
  # right now it seems like the board is updating correctly and your still in check method identifies this to be a problem,
  # but the piece still makes a ghost move; so the pawn goes one square forward, but still appears in its original position
  # on the board
# make sure you handle input that is completely wrong(like letters or 1.2)
# go through the code and optimize it
