require_relative 'lib/game'

game = Game.new
game.play

  # make it possible for the king and rook to castle
  # the king will need to know if it's in check/check mate
    # if the king is in check mate, game_over
  # look for possible ties in chess and program those in
    # you need to know what pieces each player has left
    # knowing what pieces each player has taken could also be neat, so you can track score

# look for a way to better handle the situation in which a player accidentaly selects a piece that cannot be moved, like
# selecting a rook on the first round

# make sure the player cannot select an empty space when asked what piece they'd like to choose
