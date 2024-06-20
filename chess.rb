require_relative 'lib/game'

game = Game.new
game.play

  # make sure the method that checks for check_mate takes the fact that the enemy piece giving the check can be taken
  # into account, because the array of possible moves may be empty, but the check may be solved by moving another piece
    # exclude the king from being able to be taken
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score
  # don't forget to make it possible to save the game

  # make sure you handle input that is completely wrong
