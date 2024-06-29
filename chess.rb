require_relative 'lib/game'

game = Game.new
game.play

  # make sure the method that checks for check_mate takes the fact that the enemy piece giving the check can be taken
  # into account, because the array of possible moves may be empty, but the check may be solved by moving another piece
    # to do this I need to make the #check_from...? methods return the piece that is giving the check so I can check
    # whether or not it is in 'check'

   # also make sure that the path of a rook/bishop/queen that is given the check cannot be blocked, because if it can,
   # that will fix the check
    # exclude the king from being able to be taken
    # make sure kings can't kiss
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score
  # don't forget to make it possible to save the game

  # make sure you handle input that is completely wrong
