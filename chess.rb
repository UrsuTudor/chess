require_relative 'lib/game'

game = Game.new
game.play

# make an en_passantable? instance var to pawn
  # add the en_passantable? condition to the possible takes of the pawn
  # if the pawn can move diagonally, it does so, and the piece behind it or in front of it is a pawn with en_passantalbe
  # true, remove it
  # save en_passantable

# rework opponent_piece? to work with self.player and opponent.player if possible
