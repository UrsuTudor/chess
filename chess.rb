require_relative 'lib/game'

game = Game.new
game.play

  # the king will need to know if it's in check/check mate
    # the piece can check if the king is in it's radius after its move
    # if the king is in check mate, game_over
      # remove possible moves that would be in a check
    # exclude the king from being able to be taken
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score
  # don't forget to make it possible to save the game

  # make sure you handle input that is completely wrong
