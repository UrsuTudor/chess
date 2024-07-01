require_relative 'lib/game'

game = Game.new
game.play

   # also make sure that the path of a rook/bishop/queen that is given the check cannot be blocked, because if it can,
   # that will fix the check
  # make it so the player who's king is in a check can only make moves that would fix the check
    # this means only moving the king or moving the piece that would fix the check
    # an easier way to do this may be to get the regular input and check if the king would still be in check after the
    # move is made, then returning the board to its initial state if that would be the case
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score
  # don't forget to make it possible to save the game

  # make sure you handle input that is completely wrong
